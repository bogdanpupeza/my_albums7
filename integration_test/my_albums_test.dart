import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_albums6/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Home screen test example", (WidgetTester tester) async {
    final Finder titleFinder = find.text("My Albums");
    await tester.pumpWidget(MyApp());
    expect(titleFinder, findsOneWidget);
  });

   testWidgets("Showing circular progress indicator", (WidgetTester tester) async {
    final Finder titleFinder = find.byKey(Key("title"));
    final Finder circularProgressIndicatorFinder = find.byKey(Key("circularPI"));
    await tester.pumpWidget(MyApp());
    expect(titleFinder, findsOneWidget);
    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets("Double tap test, showing last update and albums list", (WidgetTester tester) async {
    final Finder circularProgressIndicatorFinder = find.byKey(Key("circularPI"));
    final Finder lastUpdateFinder = find.byKey(Key("lastUpdate"));
    final Finder albumsListFinder = find.byKey(Key("albumsList"));
    await tester.pumpWidget(MyApp());
    await tester.tap(circularProgressIndicatorFinder);
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(circularProgressIndicatorFinder);
    await tester.pumpAndSettle(Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, Duration(seconds: 10));
    expect(lastUpdateFinder, findsOneWidget);
    expect(albumsListFinder, findsOneWidget);
  });

  testWidgets("Toggle favorite album", (WidgetTester tester) async {
    final Finder circularProgressIndicatorFinder = find.byKey(Key("circularPI"));
    final Finder lastUpdateFinder = find.byKey(Key("lastUpdate"));
    final Finder albumsListFinder = find.byKey(Key("albumsList"));
    final Finder albumFinder = find.byKey(Key("album1"));
    final Finder albumFinder2 = find.byKey(Key("album2"));
    final Finder favoriteButtonFinder = find.byKey(Key("favoriteIButton"));
    final Finder favoriteIcon = find.byKey(Key("favorite"));
    final Finder unfavoriteIcon = find.byKey(Key("unfavorite"));
    await tester.pumpWidget(MyApp());
    await tester.tap(circularProgressIndicatorFinder);
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(circularProgressIndicatorFinder);
    await tester.pumpAndSettle(Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, Duration(seconds: 10));
    expect(lastUpdateFinder, findsOneWidget);
    expect(albumsListFinder, findsOneWidget);
    expect(albumFinder, findsOneWidget);
    expect(unfavoriteIcon,  findsWidgets);
    await tester.tap(find.descendant(of: albumFinder, matching: favoriteButtonFinder));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: albumFinder2, matching: favoriteButtonFinder));
    await tester.pumpAndSettle();
    expect(find.descendant(of: albumFinder, matching: favoriteIcon), findsOneWidget);
    expect(find.descendant(of: albumFinder2, matching: favoriteIcon), findsOneWidget);
  });

}