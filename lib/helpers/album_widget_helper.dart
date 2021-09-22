import 'package:flutter/material.dart';
import 'package:my_albums6/view/album.dart';

class MyWidget extends StatelessWidget {
  final Function(int) toggleFavorite;
  final bool? isFavorite;
  final String? name;
  final int id;
  final int? userId;
  MyWidget({
    required this.isFavorite,
    required this.name,
    required this.id,
    required this.userId,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AlbumWidget(
            id: 1,
            name: 'Album test widget',
            userId: 2,
            isFavorite: false,
            toggleFavorite: toggleFavorite,
          ),
        ),
      ),
    );
  }
}
