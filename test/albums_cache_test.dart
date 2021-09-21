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
  final String _albumsCacheListKey = "albumsList";
  final String _dateKey = "dateKey";
  final String _favoritesKey = "favorites";

  MockSharedPreferences mockSharedPreferences = MockSharedPreferences();
  Future<MockSharedPreferences> sharedPrefs =
      Future.value(mockSharedPreferences);
  AlbumsCache albumsCache = AlbumsCache(sharedPrefs);

  DateTime date = DateTime.now();
  String dateString = date.toIso8601String();

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

  test("Test for getting favorites", () {
    when(mockSharedPreferences.getStringList(_favoritesKey))
        .thenAnswer((_) => (favoritesString));
    expect(
      albumsCache.getFavorites(),
      emits(favorites),
    );
  });

  test("Test for getting date", () {
    when(mockSharedPreferences.getString(_dateKey))
        .thenAnswer((_) => (dateString));
    expect(
      albumsCache.getLastDate(),
      emits(date),
    );
  });

  test("Test for getting albums", () {
    when(mockSharedPreferences.getString(_albumsCacheListKey))
        .thenAnswer((_) => (albumsString));
    expect(
      albumsCache.getAlbums(),
      emits(albums),
    );
  });
}
