import 'package:flutter/material.dart';
import 'package:my_albums6/view_model/albums_view_model.dart';
import 'package:rxdart/rxdart.dart';
import './view/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(
        AlbumsVM(
          Input(
            BehaviorSubject<bool>(),
            BehaviorSubject<int>(),
          ),
        ),
      ),
    );
  }
}
