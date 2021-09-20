import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/model/albums_cache.dart';
import 'package:my_albums6/model/albums_repository.dart';
import 'package:my_albums6/model/albums_service.dart';
import 'package:my_albums6/view_model/albums_view_model.dart';
import 'package:rxdart/subjects.dart';

import 'albums_view_model_test.mocks.dart';

@GenerateMocks([AlbumsRepository, AlbumsCache, AlbumsService])
void main(){
  
  AlbumsVM albumsVM = AlbumsVM(
    Input(
      BehaviorSubject(),
      BehaviorSubject(),
    ),
    MockAlbumsRepository(),
  );
  
  DateTime date = DateTime.now();
  List<Album> albums = [];
  for(int i = 1; i < 100; ++i){
    albums.add(
      Album(
        id: i,
        userId: i%50,
        name: "$i",
        favorite: i%2 == 0,
      )
    );
  }
  group("Test",(){
    test("for getting albums", (){
      when(albumsVM.albumsRepository.getAlbums()).thenAnswer((_) => Stream.value(AlbumsResponse(albums: albums, lastUpdate: date)));
      when(albumsVM.albumsRepository.getFavorites()).thenAnswer((_) => Stream.value([]));
      expect(
        albumsVM.output.albumsDataStream,
        emits(isA<AlbumsResponse>().having((albumsResponse){
          return albumsResponse.albums;
        }, "Albums", albums).having((albumsResponse){
          return albumsResponse.lastUpdate;
        }, "Date", date)),
      );
      albumsVM.input.loadData.add(true);
    });
  });
}