import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/model/albums_service.dart';
import 'package:http/http.dart' as http;

import 'albums_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final client = MockClient();
  final String _url = "https://jsonplaceholder.typicode.com/albums";
  AlbumsService albumsService = AlbumsService(client);
  List<Album> albums = [];
  for (int i = 1; i <= 100; ++i) {
    albums.add(Album(
      userId: i % 20,
      name: "album $i",
      id: i,
      favorite: null,
    ));
  }
  String jsonAlbums = json.encode(
    albums.map((album){
      return album.toJson();
    }
  ).toList());


  test("Test for getting albums", () {
    when(albumsService.client.get(Uri.parse(_url))).thenAnswer((_)=>Future.value(http.Response(jsonAlbums,200)));
    expect(
      albumsService.getAlbums(),
      emits(albums),
    );
  });
  test("Test for socket exception", () {
    when(albumsService.client.get(Uri.parse(_url))).thenAnswer((_)=>Future.error(SocketException("no internet connection")));
    expect(
      albumsService.getAlbums(),
      emitsError(isA<SocketException>().having((socketExeption) => socketExeption.message, "SocketException Message", "no internet connection")),
    );
  });
  test("Test for other exceptions", () {
    when(albumsService.client.get(Uri.parse(_url))).thenAnswer((_)=>Future.error(HttpException("error")));
    expect(
      albumsService.getAlbums(),
      emitsError(isA<IOException>()
      .having((error) => error.runtimeType, "Checking the error type", HttpException)
      .having((error) => error.toString(), "Checking the error and its message", HttpException("error").toString())),
    );
  });
}
