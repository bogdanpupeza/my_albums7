import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_albums6/main.dart';
import 'package:my_albums6/model/albums.dart';
import 'package:my_albums6/view/album.dart';
import 'package:my_albums6/view/home_screen.dart';
import 'package:my_albums6/view_model/albums_view_model.dart';
import 'package:rxdart/subjects.dart';

import 'home_screen_widget_test.mocks.dart';

@GenerateMocks([AlbumsVM])
void main() {
  testWidgets('Test for HomeScreen, show CircularProgressIndicator',
      (WidgetTester tester) async {
    MockAlbumsVM albumsVM = MockAlbumsVM();
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
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(albumsVM),
    ));
    final titleFinder = find.text("My Albums");
    expect(titleFinder, findsOneWidget);
    final circularPIFinder = find.byType(CircularProgressIndicator);
    expect(circularPIFinder, findsOneWidget);
  });

  testWidgets('Test for HomeScreen, show Albums Widget List',
      (WidgetTester tester) async {
    MockAlbumsVM albumsVM = MockAlbumsVM();
    when(albumsVM.output).thenReturn(
      Output(
        Stream.value(
          AlbumsResponse(
            albums: [
              Album(
                id: 1,
                name: "Album test widget1",
                userId: 1,
                favorite: false,
              ),
              Album(
                id: 2,
                name: "Album test widget2",
                userId: 2,
                favorite: true,
              ),
            ],
            lastUpdate: DateTime.now(),
          ),
        ),
      ),
    );
    when(albumsVM.input).thenReturn(
      Input(
        BehaviorSubject.seeded(true),
        BehaviorSubject.seeded(1),
      ),
    );

    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(albumsVM),
    ));
    await tester.tap(find.byType(CircularProgressIndicator));
    await tester.pump(kDoubleTapMinTime);
    await tester.pump();
    final favoriteIconFinder = find.byIcon(Icons.favorite);
    final notFavoriteIconFinder = find.byIcon(Icons.favorite_outline);
    final titleFinder = find.text("My Albums");
    final nameFinder = find.text("Album test widget1");
    final idFinder = find.text("1");
    final albumIconFinder = find.byIcon(Icons.image_rounded);
    final arrowIconFinder = find.byIcon(Icons.keyboard_arrow_right_outlined);
    expect(titleFinder, findsOneWidget);
    expect(idFinder, findsOneWidget);
    expect(nameFinder, findsOneWidget);
    expect(notFavoriteIconFinder, findsOneWidget);
    expect(favoriteIconFinder, findsOneWidget);
    expect(albumIconFinder, findsWidgets);
    expect(arrowIconFinder, findsWidgets);
  });
  
  testWidgets('Test for HomeScreen, show message for no albums',
      (WidgetTester tester) async {
    MockAlbumsVM albumsVM = MockAlbumsVM();
    when(albumsVM.output).thenReturn(
      Output(
        Stream.error(Error()),
      ),
    );
    when(albumsVM.input).thenReturn(
      Input(
        BehaviorSubject.seeded(true),
        BehaviorSubject.seeded(1),
      ),
    );

    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(albumsVM),
    ));
    await tester.tap(find.byType(CircularProgressIndicator));
    await tester.pump(kDoubleTapMinTime);
    await tester.pump();
    final titleFinder = find.text("My Albums");
    final noAlbumsTextFinder = find.text("There are no albums");
    expect(titleFinder, findsOneWidget);
    expect(noAlbumsTextFinder, findsOneWidget);
  });
}
