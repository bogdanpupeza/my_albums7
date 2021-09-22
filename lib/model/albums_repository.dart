import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../model/albums_cache.dart';
import '../model/albums_service.dart';
import '../model/albums.dart';

class AlbumsRepository {
  final AlbumsService albumsService;
  final AlbumsCache albumsCache;

  AlbumsRepository(
    this.albumsService,
    this.albumsCache,
  );

  DateTime? _lastUpdate;

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
    return(
      albumsService.getAlbums().flatMap((albumsList) {
        DateTime lastUpdate = DateTime.now();
        albumsCache.setAlbums(albumsList);
        albumsCache.setDate(lastUpdate);
      return Stream.value(
        AlbumsResponse(
          albums: albumsList,
          lastUpdate: lastUpdate,
        )
      );
      }).onErrorResume((error, stackTrace) {
      if (error is SocketException) {
        return albumsCache.getLastDate().flatMap((date) {
          return albumsCache.getAlbums().flatMap((albumsList){
            return Stream.value(
              AlbumsResponse(
                albums: albumsList,
                lastUpdate: date,
              )
            );
          });
        });
        } else {
        return Stream.error(FlutterError("Something went wrong"));
        }
      })
    );
  }
}
