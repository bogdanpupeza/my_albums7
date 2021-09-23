import 'package:flutter/material.dart';
import 'package:my_albums6/model/albums_cache.dart';
import 'package:my_albums6/model/albums_repository.dart';
import 'package:my_albums6/model/albums_service.dart';
import 'package:my_albums6/model/date_update.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; 
import '../model/albums.dart';
import './album.dart';
import '../view_model/albums_view_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

extension on Duration{
  String get showLastUpdate{
    String duration = "";
    if(inDays > 0){
      duration += "${(inDays.toString())} days ";
    } else {
      if(inHours > 0) {
        int hours = inHours % 24;
        duration += "${(hours.toString())} hours ";
        if(inMinutes > 0){
          int minutes = inMinutes % 60;
          duration += "${(minutes.toString())} minutes ";
        }
      } else {
        if(inMinutes > 0){
          int minutes = inMinutes % 60;
          duration += "${(minutes.toString())} minutes ";
        }
        if(inSeconds >= 0){
          int seconds = inSeconds % 60;
          duration += "${(seconds.toString())} seconds";
        }
      }
    }
    return duration;
  }
}


class _HomeScreenState extends State<HomeScreen> {
 
  AlbumsVM albumsVM = AlbumsVM(
    Input(
      BehaviorSubject<bool>(),
      BehaviorSubject<int>(),
    ),
    AlbumsRepository(
      AlbumsService(http.Client()),
      AlbumsCache(SharedPreferences.getInstance()),
      DateUpdate(),
    ),
  );

  void getAlbums() {
   albumsVM.input.loadData.add(true);
  }

  void toggleFavorite(int albumId){
    albumsVM.input.toggleFavorite.add(albumId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Albums"),
      ),
      body: Center(
        child: GestureDetector(
          child: StreamBuilder<AlbumsResponse>(
              stream: albumsVM.output.albumsDataStream,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data != null) {
                    var data = snapshot.data as AlbumsResponse;
                    var albums = data.albums;
                    var lastUpdate = data.lastUpdate;
                    Duration duration = const Duration();
                    if(lastUpdate != null){
                      duration = DateTime.now().difference(lastUpdate);
                    }
                    return Column(
                      children: [
                        if (duration.inSeconds >= 5)
                          Text("Results updated ${(duration.showLastUpdate)} ago"),
                        if (duration.inSeconds < 5)
                          const Text("Results updated just now"),
                        Expanded(
                          child: ListView.builder(
                            itemCount: albums.length,
                            itemBuilder: (ctx, index) {
                              return AlbumWidget(
                                toggleFavorite: toggleFavorite,
                                isFavorite: albums[index].favorite,
                                name: albums[index].name,
                                id: albums[index].id,
                                userId: albums[index].userId,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return (const Text("There are no albums"));
                  }
                }
              }),
          onDoubleTap: getAlbums,
        ),
      ),
    );
  }
}
