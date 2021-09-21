import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
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
  AlbumsService albumsService = AlbumsService();
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
  Response response = http.Response(jsonAlbums,200);
  test("Test for getting albums", () {
    when(client.get(Uri.parse(_url))).thenAnswer((_)=>Future.value(response));
    expect(
      albumsService.getAlbums(),
      emits(isA<List<Album>>().having((p0){
        return p0.last.userId;
      }, "description", albums.last.userId)),
    );
  });
}
