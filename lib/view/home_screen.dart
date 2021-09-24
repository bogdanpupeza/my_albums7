import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

import '../model/albums.dart';
import './album.dart';
import '../view_model/albums_view_model.dart';

class HomeScreen extends StatefulWidget {
  final AlbumsVM? albumsVM;
  HomeScreen([this.albumsVM]);
  @override
  _HomeScreenState createState() => _HomeScreenState(
    albumsVM == null ? AlbumsVM(Input(BehaviorSubject<bool>(), BehaviorSubject<int>())):albumsVM!
  );
}

extension on Duration {
  String get showLastUpdate {
    String duration = "";
    if (inDays > 0) {
      duration += "${(inDays.toString())} days ";
    } else {
      if (inHours > 0) {
        int hours = inHours % 24;
        duration += "${(hours.toString())} hours ";
        if (inMinutes > 0) {
          int minutes = inMinutes % 60;
          duration += "${(minutes.toString())} minutes ";
        }
      } else {
        if (inMinutes > 0) {
          int minutes = inMinutes % 60;
          duration += "${(minutes.toString())} minutes ";
        }
        if (inSeconds >= 0) {
          int seconds = inSeconds % 60;
          duration += "${(seconds.toString())} seconds";
        }
      }
    }
    return duration;
  }
}

class _HomeScreenState extends State<HomeScreen> {

  final AlbumsVM albumsVM;

  _HomeScreenState(this.albumsVM);

  void getAlbums() {
    albumsVM.input.loadData.add(true);
  }

  void toggleFavorite(int albumId) {
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
                    if (lastUpdate != null) {
                      duration = DateTime.now().difference(lastUpdate);
                    }
                    return Column(
                      children: [
                        if (duration.inSeconds >= 5)
                          Text(
                              "Results updated ${(duration.showLastUpdate)} ago"),
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
