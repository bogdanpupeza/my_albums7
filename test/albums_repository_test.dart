import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/model/albums_cache.dart';
import 'package:my_albums6/model/albums_repository.dart';
import 'package:my_albums6/model/albums_service.dart';
import 'package:mockito/mockito.dart';
import 'albums_repository_test.mocks.dart';

@GenerateMocks([AlbumsCache, AlbumsService])
void main() {
  AlbumsService albumsService = MockAlbumsService();
  AlbumsCache albumsCache = MockAlbumsCache();
  AlbumsRepository albumsRepository =
      AlbumsRepository(albumsService, albumsCache);
  List<Album> albums = [];
  List<int> favorites = [];

  for (int i = 1; i <= 100; ++i) {
    albums.add(Album(
      id: i,
      name: "$i",
      favorite: i % 2 == 0,
      userId: i % 30,
    ));
    if (i % 2 == 0) favorites.add(i);
  }

  DateTime date = DateTime.now();

  group("Tests for getAlbums()", () {
    test("Test for getting albums from Service and dateTime for lastUpdate", () {
      when(albumsCache.getLastDate()).thenAnswer((_) {
        return Stream.value(date);
      });
      when(albumsService.getAlbums()).thenAnswer((_) {
        return Stream.value(albums);
      });
      expect(
        albumsRepository.getAlbums(),
        emits(isA<AlbumsResponse>().having((albumResponse) {
          return albumResponse.albums;
        }, "test if we get albums from albums response", albums).having(
            (albumResponse) {
          return albumResponse.lastUpdate;
        }, "test if we get date from albums response", date)),
      );
    });

    test(
        "Test for getting albums from Cache and dateTime for lastUpdate when there is no internet connection",
        () {
      when(albumsCache.getLastDate()).thenAnswer((_) {
        return Stream.value(date);
      });
      when(albumsCache.getAlbums()).thenAnswer((_) {
        return Stream.value(albums);
      });
      when(albumsService.getAlbums())
          .thenAnswer((_) => Stream.error(SocketException("")));
      expect(
        albumsRepository.getAlbums(),
        emits(isA<AlbumsResponse>().having((albumResponse) {
          return albumResponse.albums;
        }, "test if we get albums from albums response", albums).having(
            (albumResponse) {
          return albumResponse.lastUpdate;
        }, "test if we get date from albums response", date)),
      );
    });
    test(
        "Test for getting error from Cache when there are no albums saved",
        () {
        when(albumsCache.getLastDate()).thenAnswer((_) {
          return Stream.value(date);
        });
        when(albumsCache.getAlbums()).thenAnswer((_) {
          return Stream.error(Exception());
        });
        when(albumsService.getAlbums())
            .thenAnswer((_) => Stream.error(Exception("")));
        expect(
          albumsRepository.getAlbums(),
          emits(isA<Exception>()),
        );
    });
  });

  test("Test for getting favorites", () {
    when(albumsCache.getFavorites()).thenAnswer((_) {
      return Stream.value(favorites);
    });
    expect(albumsRepository.getFavorites(), emits(favorites));
  });

  test("Test for toggleAlbum()", (){
    when(albumsCache.getFavorites()).thenAnswer((_) {
      return Stream.value(favorites);
    });
    when(albumsCache.setFavorites(favorites));
    expect(albumsRepository.toggleAlbum(1), emits(favorites));

    verify(albumsCache.setFavorites(favorites));
  });
}
