import 'package:flutter_test/flutter_test.dart';
import 'package:my_albums6/model/albums_service.dart';

void main(){
  AlbumsService albumsService = AlbumsService();
  List<int> albums = [];
  for(int i = 1; i <= 100; ++i)
  {
    albums.add(i);
  }
  test("Test if we get albums in order", (){
    expect(
      albumsService.getAlbums().map(
        (albumsData){
          return albumsData.map(
            (album){
              return album.id;
            }
          ).toList();
        }
      ), 
      emits(albums)
    );
  });
}