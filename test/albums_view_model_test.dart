import 'package:flutter_test/flutter_test.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/view_model/albums_view_model.dart';
import 'package:rxdart/subjects.dart';

void main(){
  AlbumsVM albumsVM = AlbumsVM(Input(BehaviorSubject(), BehaviorSubject()));
  test("Test for AlbumsVM", (){
    // expect(
    //   albumsVM.output.stream, 
    //   emits(AlbumsResponse(albums: albums, lastUpdate: lastUpdate),
    // ));
  });
}