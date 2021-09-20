import 'dart:io';

import 'package:flutter/foundation.dart';
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
  AlbumsResponse albumsResponse = AlbumsResponse(
    albums: albums,
    lastUpdate: date,
  );

  group("Tests for getting albums ", () {
    test("from Service", () {
      when(albumsCache.getLastDate()).thenAnswer((_) {
        return Stream.value(date);
      });
      when(albumsService.getAlbums()).thenAnswer((_) {
        return Stream.value(albums);
      });
      expect(
          albumsRepository.getAlbums().map((albumsResponse2) {
            return albumsResponse2.albums;
          }),
          emits(albumsResponse.albums));
      albumsCache.setAlbums(albums);
      albumsCache.setDate(date);
    });

    test("from Cache", () {
      when(albumsCache.getLastDate()).thenAnswer((_) {
        return Stream.value(date);
      });
      when(albumsCache.getAlbums()).thenAnswer((_) {
        return Stream.value(albums);
      });
      when(albumsService.getAlbums())
          .thenAnswer((_) => Stream.error(SocketException("")));
      expect(
        albumsRepository.getAlbums().map((albumsResponse2) {
          return albumsResponse2.albums;
        }),
        emits(albumsResponse.albums),
      );
    });
  });

  test("Test for getting favorites", () {
    when(albumsCache.getFavorites()).thenAnswer((_) {
      return Stream.value(favorites);
    });
    expect(albumsRepository.toggleAlbum(1), emits(favorites));
  });
}
