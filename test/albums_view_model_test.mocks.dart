// Mocks generated by Mockito 5.0.16 from annotations
// in my_albums6/test/albums_view_model_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:my_albums6/model/albums.dart' as _i6;
import 'package:my_albums6/model/albums_cache.dart' as _i3;
import 'package:my_albums6/model/albums_repository.dart' as _i4;
import 'package:my_albums6/model/albums_service.dart' as _i2;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeAlbumsService_0 extends _i1.Fake implements _i2.AlbumsService {}

class _FakeAlbumsCache_1 extends _i1.Fake implements _i3.AlbumsCache {}

/// A class which mocks [AlbumsRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAlbumsRepository extends _i1.Mock implements _i4.AlbumsRepository {
  MockAlbumsRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AlbumsService get albumsService =>
      (super.noSuchMethod(Invocation.getter(#albumsService),
          returnValue: _FakeAlbumsService_0()) as _i2.AlbumsService);
  @override
  _i3.AlbumsCache get albumsCache =>
      (super.noSuchMethod(Invocation.getter(#albumsCache),
          returnValue: _FakeAlbumsCache_1()) as _i3.AlbumsCache);
  @override
  _i5.Stream<List<int>> toggleAlbum(int? id) =>
      (super.noSuchMethod(Invocation.method(#toggleAlbum, [id]),
          returnValue: Stream<List<int>>.empty()) as _i5.Stream<List<int>>);
  @override
  _i5.Stream<List<int>> getFavorites() =>
      (super.noSuchMethod(Invocation.method(#getFavorites, []),
          returnValue: Stream<List<int>>.empty()) as _i5.Stream<List<int>>);
  @override
  _i5.Stream<_i6.AlbumsResponse> getAlbums() =>
      (super.noSuchMethod(Invocation.method(#getAlbums, []),
              returnValue: Stream<_i6.AlbumsResponse>.empty())
          as _i5.Stream<_i6.AlbumsResponse>);
  @override
  String toString() => super.toString();
}
