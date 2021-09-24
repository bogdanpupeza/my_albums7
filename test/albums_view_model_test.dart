import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/model/albums_repository.dart';
import 'package:my_albums6/view_model/albums_view_model.dart';
import 'package:rxdart/subjects.dart';

import 'albums_view_model_test.mocks.dart';

@GenerateMocks([AlbumsRepository])
void main() {
  AlbumsVM albumsVM = AlbumsVM(
    Input(
      BehaviorSubject(),
      BehaviorSubject(),
    ),
    MockAlbumsRepository(),
  );

  DateTime date = DateTime.now();
  List<Album> albums = [];
  for (int i = 1; i < 100; ++i) {
    albums.add(Album(
      id: i,
      userId: i % 50,
      name: "$i",
      favorite: false,
    ));
  }
  Stream<AlbumsResponse> resultStream =
      albumsVM.output.albumsDataStream.asBroadcastStream();
  test("Test for getting albumsRespomse and an empty favorites list: albumsRepository.getAlbums(), albumsRepository.getFavorites()", () {
    when(albumsVM.albumsRepository.getAlbums()).thenAnswer(
        (_) => Stream.value(AlbumsResponse(albums: albums, lastUpdate: date)));
    when(albumsVM.albumsRepository.getFavorites())
        .thenAnswer((_) => Stream.value([]));
    expect(
      resultStream,
      emits(isA<AlbumsResponse>().having((albumsResponse) {
        return albumsResponse.albums;
      }, "List of Albums", albums).having((albumsResponse) {
        return albumsResponse.lastUpdate;
      }, "Date of lastUpdate", date)),
    );
    albumsVM.input.loadData.add(true);
  });

  test("Test for setting first album as favorite: albumsRepository.toggleAlbum(1): ", () {
    when(albumsVM.albumsRepository.getAlbums()).thenAnswer(
        (_) => Stream.value(AlbumsResponse(albums: albums, lastUpdate: date)));
    when(albumsVM.albumsRepository.getFavorites())
        .thenAnswer((_) => Stream.value([]));
    when(albumsVM.albumsRepository.toggleAlbum(1))
        .thenAnswer((_) => Stream.value([1]));
    expect(
        resultStream,
        emits(isA<AlbumsResponse>().having(
            (albumsResponse) => albumsResponse.albums.first.favorite,
            "first element has favorite = true",
            true)));
    albumsVM.input.loadData.add(true);
    albumsVM.input.toggleFavorite.add(1);
  });

  test("Test for getting error: albumsRepository.getAlbums()", () {
    when(albumsVM.albumsRepository.getAlbums())
        .thenAnswer((_) => Stream.error(Error()));
    expect(
      resultStream,
      emitsError(isA<Error>()),
    );
    albumsVM.input.loadData.add(true);
  });

  test("Test for getting error: albumsRepository.getFavorites()", () {
    when(albumsVM.albumsRepository.getFavorites())
        .thenAnswer((_) => Stream.error(Error()));
    expect(
      resultStream,
      emitsError(isA<Error>()),
    );
    albumsVM.input.loadData.add(true);
  });

  test("Test for getting error: albumsRepository.toggleAlbum(albumId)", () {
    when(albumsVM.albumsRepository.getAlbums()).thenAnswer(
        (_) => Stream.value(AlbumsResponse(albums: albums, lastUpdate: date)));
    when(albumsVM.albumsRepository.getFavorites())
        .thenAnswer((_) => Stream.value([] as List<int>));
    when(albumsVM.albumsRepository.toggleAlbum(1))
        .thenAnswer((_) => Stream.error(Error()));
    expect(
      resultStream,
      emitsError(isA<Error>()),
    );
    albumsVM.input.loadData.add(true);
  });
}
