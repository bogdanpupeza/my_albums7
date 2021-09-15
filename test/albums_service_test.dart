import 'package:flutter_test/flutter_test.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/model/albums_service.dart';

void main(){
  AlbumsService albumsService = AlbumsService();
  List<Album> albums = [
    Album(
      id: 1,
      userId: 1,
      name: "AAA",
    ),
  ];
  test("Test if we get an error", (){
    expect(
      albumsService.getAlbums(), 
      emits(albums),
    );
  });
}