import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/model/albums_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'albums_cache_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  MockSharedPreferences mockSharedPreferences = MockSharedPreferences();
  Future<MockSharedPreferences> sharedPrefs =
      Future.value(mockSharedPreferences);
  AlbumsCache albumsCache = AlbumsCache(sharedPrefs);



  List<Album> albums = [];
  List<String> favoritesString = [];
  List<int> favorites = [];
  for (int i = 0; i < 100; ++i) {
    favoritesString.add("$i");
    favorites.add(i);
    albums.add(Album(
      id: i,
      userId: i % 33,
      name: "$i",
      favorite: i % 2 == 0,
    ));
  }
  String albumsString = jsonEncode(albums.map((album) {
    return album.toJson();
  }).toList());

  test("Test for setting favorites", () async {
    final String _favoritesKey = "favorites";
    when(mockSharedPreferences.setStringList(_favoritesKey, favoritesString))
        .thenAnswer((_) => Future.value(true));
    await albumsCache.setFavorites(favorites);
    verify(mockSharedPreferences.setStringList(_favoritesKey, favoritesString));
  });

  test("Test for getting favorites", () {
    final String _favoritesKey = "favorites";
    when(mockSharedPreferences.getStringList(_favoritesKey))
        .thenAnswer((_) => (favoritesString));
    expect(
      albumsCache.getFavorites(),
      emits(favorites),
    );
  });
  test("Test for getting an empty list we try to get favorites", ()  {
    final String _favoritesKey = "favorites";
    when(mockSharedPreferences.getStringList(_favoritesKey))
        .thenThrow((_)=>Future.value(Error));
    expect(
      albumsCache.getFavorites(),
      emits([]),
    );
  });

  test("Test for setting date", () async {
    final String _dateKey = "dateKey";
    DateTime date = DateTime.now();
    String dateString = date.toIso8601String();

    when(mockSharedPreferences.setString(_dateKey, dateString))
        .thenAnswer((_) => Future.value(true));
    await albumsCache.setDate(date);
    verify(mockSharedPreferences.setString(_dateKey, dateString));
  });

  test("Test for getting date", () {
    final String _dateKey = "dateKey";
    DateTime date = DateTime.now();
    String dateString = date.toIso8601String();
    when(mockSharedPreferences.getString(_dateKey))
        .thenAnswer((_) => (dateString));
    expect(
      albumsCache.getLastDate(),
      emits(date),
    );
  });
  test("Test for getting null when we try to get date", ()  {
    final String _dateKey = "dateKey";
    when(mockSharedPreferences.getString(_dateKey))
        .thenThrow((_)=>Future.value(Error));
    expect(
      albumsCache.getLastDate(),
      emits(null),
    );
  });

  test("Test for setting albums", () async {
    final String _albumsCacheListKey = "albumsList";
    when(mockSharedPreferences.setString(_albumsCacheListKey, albumsString))
        .thenAnswer((_) => Future.value(true));
    await albumsCache.setAlbums(albums);
    verify(mockSharedPreferences.setString(_albumsCacheListKey, albumsString));
  });
  
  test("Test for getting albums", () {
    final String _albumsCacheListKey = "albumsList";
    when(mockSharedPreferences.getString(_albumsCacheListKey))
        .thenAnswer((_) => (albumsString));
    expect(
      albumsCache.getAlbums(),
      emits(albums),
    );
  });
  test("Test for getting error when we try to get albums", ()  {
    final String _albumsCacheListKey = "albumsList";
    when(mockSharedPreferences.getString(_albumsCacheListKey))
        .thenThrow((_)=>Future.value(Exception));
    expect(
      albumsCache.getAlbums(),
      emitsError(isA<Exception>()),
    );
  });
}
