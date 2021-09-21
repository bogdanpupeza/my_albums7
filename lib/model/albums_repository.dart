import 'dart:io';

import 'package:rxdart/rxdart.dart';
import '../model/albums_cache.dart';
import '../model/albums_service.dart';
import '../model/albums.dart';


class AlbumsRepository{

  final AlbumsService albumsService;
  final AlbumsCache albumsCache;

  AlbumsRepository(
    this.albumsService,
    this.albumsCache,
  );

  DateTime? _lastUpdate;

  Stream<List<int>> toggleAlbum(int id){
    Stream<List<int>> favoritesStream = albumsCache.getFavorites();
    Stream<List<int>> actualFavorites = favoritesStream.map((favorites){
      if(favorites.any((element) => element == id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
      albumsCache.setFavorites(favorites);
      return favorites;
    });
    return actualFavorites;
  }

  Stream<List<int>> getFavorites(){
    return albumsCache.getFavorites();
  }

  Stream<AlbumsResponse> getAlbums(){
    _lastUpdate = DateTime.now();
    return
    albumsService.getAlbums().map((albumsList){
      albumsCache.setAlbums(albumsList);
      albumsCache.setDate(DateTime.now());
      return albumsList;
    }).onErrorResume(
      (error, stackTrace){
        if(error is SocketException){
          return albumsCache.getLastDate().flatMap((date){
            _lastUpdate = date;
            return albumsCache.getAlbums();
          });
        }
        throw error;
      }
    ).flatMap((albumsList){
      return Stream.value(AlbumsResponse(albums: albumsList, lastUpdate: _lastUpdate));
    });
  }
}