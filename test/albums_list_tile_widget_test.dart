import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/helpers/album_widget_helper.dart';

void main() {
  void toggleFavorite(int id) {}
  testWidgets('Test for Album Widget', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      id: 1,
      name: 'Album test widget',
      userId: 1,
      isFavorite: false,
      toggleFavorite: toggleFavorite,
    ));

    final idFinder = find.text("1");
    final nameFinder = find.text("Album test widget");
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
