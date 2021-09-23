import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_albums6/main.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/view/album.dart';
import 'package:my_albums6/view/home_screen.dart';
import 'package:my_albums6/view_model/albums_view_model.dart';

import 'home_screen_widget_test.mocks.dart';

@GenerateMocks([AlbumsVM])
void main() {
  testWidgets('Test for HomeScreen', (WidgetTester tester) async {
    MockAlbumsVM albumsVM = MockAlbumsVM();
    // int id = 1;
    // int? userId;
    // String? name = "Album test widget";
    // bool? isFavorite;
    // void toggleFavorite(int id) {
    //   if(isFavorite == null) {
    //     isFavorite = true;
    //   } else {
    //     isFavorite = !isFavorite!;
    //   }
    // }
    when(albumsVM.output.albumsDataStream).thenAnswer((_) => Stream.value(AlbumsResponse(albums: [], lastUpdate: DateTime.now())));
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(albumsVM),
    ));

    final  titleFinder = find.text("My Albums");
    expect (titleFinder, findsOneWidget);
    // final nameFinder = find.text("Album test widget");
    // final notFavoriteIconFinder = find.byIcon(Icons.favorite_outline);
    // final albumIconFinder = find.byIcon(Icons.image_rounded);
    // final arrowIconFinder = find.byIcon(Icons.keyboard_arrow_right_outlined);
    // expect(idFinder, findsOneWidget);
    // expect(nameFinder, findsOneWidget);
    // expect(notFavoriteIconFinder, findsOneWidget);
    // expect(albumIconFinder, findsOneWidget);
    // expect(arrowIconFinder, findsOneWidget);
  });

  testWidgets('Test for Album Widget: changing isFavorite from null/false to true', (WidgetTester tester) async {
    int id = 0;
    int? userId;
    String? name;
    bool? isFavorite;
    void toggleFavorite(int id) {
      if(isFavorite == null) {
        isFavorite = true;
      } else {
        isFavorite = !isFavorite!;
      }
    }
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: AlbumWidget(
            id: id,
            name: name,
            userId: userId,
            isFavorite: isFavorite,
            toggleFavorite: toggleFavorite,
          ),
        ),
      ),
    ));
    final notFavoriteButton = find.ancestor(of: find.byIcon(Icons.favorite_outline), matching: find.byType(IconButton));
    final favoriteButton = find.ancestor(of: find.byIcon(Icons.favorite), matching: find.byType(IconButton));
    await tester.tap(notFavoriteButton);
    await tester.pump();
    expect(isFavorite, true);
    expect(favoriteButton, findsNothing);
  });

  testWidgets('Test for Album Widget: if name is null, show Text("Unnamed") ', (WidgetTester tester) async {
    int id = 1;
    int? userId;
    String? name;
    bool? isFavorite;
    void toggleFavorite(int id) {
      if(isFavorite == null) {
        isFavorite = true;
      } else {
        isFavorite = !isFavorite!;
      }
    }
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: AlbumWidget(
            id: id,
            name: name,
            userId: userId,
            isFavorite: isFavorite,
            toggleFavorite: toggleFavorite,
          ),
        ),
      ),
    ));
    //TestAlbumsWidget(id, userId, name, isFavorite, toggleFavorite)
    final idFinder = find.text("1");
    final nameFinder = find.text("Unnamed album");
    expect(idFinder, findsOneWidget);
    expect(nameFinder, findsOneWidget);
  });
}
