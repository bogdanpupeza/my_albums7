import 'package:flutter/material.dart';

class AlbumWidget extends StatelessWidget {
  final Key albumCircleAvatarKey = Key("albumCircleAvatar");
  final Key albumTitleKey = Key("albumTitle");
  final Key albumIdTextKey = Key("albumIdText");
  final Key keyboardArrowIButtonKey = Key("keyboardArrowIButton");
  final Key favoriteIButtonKey = Key("favoriteIButton");
  final Key favoriteIconKey = Key("favorite");
  final Key unfavoriteIconKey = Key("unfavorite");

  final Key key;
  final Function(int) toggleFavorite;
  final bool? isFavorite;
  final String? name;
  final int id;
  final int? userId;
  AlbumWidget({
    required this.key,
    required this.isFavorite,
    required this.name,
    required this.id,
    required this.userId,
    required this.toggleFavorite,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.amber,
      ),
      child: Row(children: [
        Container(
          margin: EdgeInsets.all(15),
          child: CircleAvatar(
            child: Icon(Icons.image_rounded),
            key: albumCircleAvatarKey
          ),
        ),
        Expanded(
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 15),
              alignment: Alignment.centerLeft,
              height: 40,
              child: Text(
                name.toString(),
                key: albumTitleKey,
                overflow: TextOverflow.fade,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              alignment: Alignment.centerLeft,
              child: Text(
                id.toString(),
                key: albumIdTextKey,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        )),
        IconButton(
          key: keyboardArrowIButtonKey,
          icon: Icon(Icons.keyboard_arrow_right_outlined),
          onPressed: () {},
        ),
        IconButton(
          key: favoriteIButtonKey,
          onPressed: () => toggleFavorite(id),
          icon: 
              isFavorite == true
              ? Icon(Icons.favorite, key: favoriteIconKey)
              : Icon(Icons.favorite_border, key:unfavoriteIconKey),
        ),
      ]),
    );
  }
}
