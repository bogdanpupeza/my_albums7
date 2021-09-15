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

  
  Stream<AlbumsResponse> getAlbums(){
    DateTime? oldDate;
    _lastUpdate = DateTime.now();
    bool isError = false;
    
    Stream<DateTime?> dateStream = albumsCache.getLastDate();

    Stream<List<Album>> albumsStream = 
    albumsService.getAlbums().handleError(
      (error, stackTrace){
        if(error is SocketException){
          _lastUpdate = oldDate;
          isError = true;
          return albumsCache.getAlbums();
        }
        throw error;
      }
    );

      Stream<AlbumsResponse> albumsResponse = albumsStream.map((albumsList){
        if(!isError){
          albumsCache.setAlbums(albumsList);
          albumsCache.setDate(DateTime.now());
        }
        return AlbumsResponse(albums: albumsList, lastUpdate: _lastUpdate);
      });

      return Rx.combineLatest2(
        albumsResponse, 
        dateStream, 
        (AlbumsResponse albumsResponse, DateTime? date){
          if(date != null)
            _lastUpdate = date;
          return AlbumsResponse(albums: albumsResponse.albums, lastUpdate: _lastUpdate);
        }
      );
  }
  
  
}