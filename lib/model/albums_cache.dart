import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/albums.dart';

class AlbumsCache{
  final String _albumsCacheListKey = "albumsList";
  final String _dateKey = "dateKey";
  final String _favoritesKey = "favorites";
  final Future<SharedPreferences> sharedPreferences;
  AlbumsCache(this.sharedPreferences);
  
  Stream<List<Album>> getAlbums (){
    List<Album> albumsList = [];
    List<dynamic> responseJson;
    String response;
    return Stream.fromFuture(
      sharedPreferences.then(
        (pref){
          response = pref.getString(_albumsCacheListKey) as String;
          responseJson = jsonDecode( response);
          albumsList = responseJson.map((element) => Album.fromJson(element)).toList();
          return albumsList;
        }
      ).onError((error, stackTrace){
        throw Exception(); 
      })
    );
  }
  
  Stream<bool> setAlbums(List<Album> albums){
    return sharedPreferences.then(
      (pref){
        String jsonData = jsonEncode(
          albums.map((album){
            return album.toJson();
          }).toList()
        );
        return pref.setString(_albumsCacheListKey, jsonData);
      }
    ).asStream();
  }

  Stream<bool> setDate(DateTime dateTime){
    return sharedPreferences.then(
      (pref){
        String dateString = dateTime.toIso8601String();
        return pref.setString(_dateKey, dateString);
      }
    ).asStream();
  }

  Stream<DateTime?> getLastDate (){
    DateTime? dateTime;
    String dateString;
    return Stream.fromFuture(
      sharedPreferences.then(
        (pref){
          dateString = pref.getString(_dateKey) as String;
          dateTime = DateTime.parse(dateString);
          return dateTime;
        }
      ).onError((error, stackTrace){
        return null;
      })
    );
  }

  Stream<List<int>> getFavorites(){
    List<int> favorites = [];
    List<String> response;
    return Stream.fromFuture(
      sharedPreferences.then(
        (pref){
          response = pref.getStringList(_favoritesKey) as List<String>;
          favorites = response.map((idString){
            return int.parse(idString);
          }).toList();
          return favorites;
        }
      ).onError((error, stackTrace){
        return [];
      })
    );
  }

  Stream<bool> setFavorites (List<int> favorites){
    return sharedPreferences.then(
      (pref){
        List<String> ids =
          favorites.map((albumId){
            return albumId.toString();
          }).toList();
        return pref.setStringList(_favoritesKey, ids);
      }
    ).asStream();
  }
}
