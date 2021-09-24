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
  testWidgets('Test for HomeScreen, show CircularProgressIndicator', (WidgetTester tester) async {
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
    when(albumsVM.output).thenReturn(
      Output(
        Stream.value(
          AlbumsResponse(
            albums: [
              Album(
                id: 1,
                name: "Album test widget",
                userId: 1,
                favorite: true,
              ),
            ],
            lastUpdate: DateTime.now(),
          ),
        ),
      ),
    );
    //albumsVM.input.loadData.add(true);
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(albumsVM),
    ));

    final titleFinder = find.text("My Albums");
    expect (titleFinder, findsOneWidget);
    final circularPIFinder = find.byType(CircularProgressIndicator);
    expect (circularPIFinder, findsOneWidget);
    // final nameFinder = find.text("Album test widget");
    // final idFinder = find.text("1");
    // final notFavoriteIconFinder = find.byIcon(Icons.favorite_outline);
    // final albumIconFinder = find.byIcon(Icons.image_rounded);
    // final arrowIconFinder = find.byIcon(Icons.keyboard_arrow_right_outlined);
    // expect(idFinder, findsOneWidget);
    // expect(nameFinder, findsOneWidget);
    // expect(notFavoriteIconFinder, findsOneWidget);
    // expect(albumIconFinder, findsOneWidget);
    // expect(arrowIconFinder, findsOneWidget);
  });

  testWidgets('Test for HomeScreen, show WidgetList', (WidgetTester tester) async {
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
    when(albumsVM.output).thenReturn(
      Output(
        Stream.value(
          AlbumsResponse(
            albums: [
              Album(
                id: 1,
                name: "Album test widget",
                userId: 1,
                favorite: true,
              ),
            ],
            lastUpdate: DateTime.now(),
          ),
        ),
      ),
    );
    //albumsVM.input.loadData.add(true);
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(albumsVM),
    ));

    final titleFinder = find.text("My Albums");
    expect (titleFinder, findsOneWidget);
    albumsVM.input.loadData.add(true);
    final nameFinder = find.text("Album test widget");
    final idFinder = find.text("1");
    final notFavoriteIconFinder = find.byIcon(Icons.favorite_outline);
    final albumIconFinder = find.byIcon(Icons.image_rounded);
    final arrowIconFinder = find.byIcon(Icons.keyboard_arrow_right_outlined);
    expect(idFinder, findsOneWidget);
    expect(nameFinder, findsOneWidget);
    expect(notFavoriteIconFinder, findsOneWidget);
    expect(albumIconFinder, findsOneWidget);
    expect(arrowIconFinder, findsOneWidget);
  });
}
