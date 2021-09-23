import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/albums.dart';

class AlbumsService {
  final noInternetConnectionMessage = "no internet connection";
  final unknownExceptionMessage = "unknown exeption";
  final String _url = "https://jsonplaceholder.typicode.com/albums";
  final http.Client client;
  AlbumsService(this.client);
  
  Stream<List<Album>> getAlbums () {
    
    List<dynamic> responseJson;
    List<Album> albums = [];
    return Stream.fromFuture(
      client.get(Uri.parse(_url)).then(
        (response){
          responseJson = jsonDecode(response.body);
          albums = responseJson.map((element) {
            return Album.fromJson(element);
          }).toList();
          return albums;
        }
      ).onError<IOException>((error, stackTrace){
        if(error is SocketException)
          throw SocketException(noInternetConnectionMessage);
        throw error;
      })
    );
  }


}