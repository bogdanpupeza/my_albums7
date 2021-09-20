import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/model/albums_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'albums_cache_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main(){
  SharedPreferences.setMockInitialValues({"key": 3});
  AlbumsCache albumsCache = AlbumsCache(SharedPreferences.getInstance());
  SharedPreferences.setMockInitialValues({});
  List<Album> albums = [];
  for(int i = 0; i < 100; ++i){
    albums.add(
      Album(
        id: i,
        userId: i % 33,
        name: "$i",
        favorite: i % 2 == 0,
      )
    );
  }
  test("Test if we get an error", (){
    
    expect(
      albumsCache.getAlbums(), 
      emits(albums),
    );
    
  });
}