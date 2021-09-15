import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/albums.dart';

class AlbumsService {
  final String _url = "https://jsonplaceholder.typicode.com/albums";
  
  Stream<List<Album>> getAlbums () {
    
    List<dynamic> responseJson;
    List<Album> albums = [];
    var response;
    return Stream.fromFuture(
      http.get(Uri.parse(_url)).then(
        (value){
          response = value;
          responseJson = jsonDecode(response.body);
          albums = responseJson.map((element) {
            return Album.fromJson(element);
          }).toList();
          return albums;
        }
      ).onError((error, stackTrace){
        if(error is SocketException)
          throw SocketException("No internet connection");
        throw stackTrace;
      })
    );
  }


}