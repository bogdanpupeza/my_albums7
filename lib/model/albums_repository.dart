import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_albums6/model/date_update.dart';
import 'package:rxdart/rxdart.dart';
import '../model/albums_cache.dart';
import '../model/albums_service.dart';
import '../model/albums.dart';

class AlbumsRepository {
  final AlbumsService albumsService;
  final AlbumsCache albumsCache;
  final DateUpdate dateUpdate;


  AlbumsRepository(this.albumsService, this.albumsCache, this.dateUpdate);

  Stream<List<int>> toggleAlbum(int id) {
    return albumsCache.getFavorites().map((favorites) {
      if (favorites.any((element) => element == id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
      albumsCache.setFavorites(favorites);
      return favorites;
    });
  }

  Stream<List<int>> getFavorites() {
    return albumsCache.getFavorites();
  }

  Stream<AlbumsResponse> getAlbums() {
    return (albumsService.getAlbums().map((albumsList) {
      DateTime lastUpdate = dateUpdate.getDate;
      albumsCache.setAlbums(albumsList);
      albumsCache.setDate(lastUpdate);
      return AlbumsResponse(
        albums: albumsList,
        lastUpdate: lastUpdate,
      );
    }).onErrorResume((error, stackTrace) {
      if (error is SocketException) {
        return albumsCache.getAlbums().flatMap((albumsList) {
          return albumsCache.getLastDate().map((date) {
            return AlbumsResponse(
              albums: albumsList,
              lastUpdate: date,
            );
          });
        });
      } else {
        return Stream.error(FlutterError(error.toString()));
      }
    }));
  }
}
