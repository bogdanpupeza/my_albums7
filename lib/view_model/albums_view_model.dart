import 'package:my_albums6/model/albums_cache.dart';
import 'package:my_albums6/model/date_update.dart';
import 'package:rxdart/rxdart.dart';
import '../model/albums.dart';
import '../model/albums_repository.dart';
import '../model/albums_service.dart';
import 'package:http/http.dart' as http;

class AlbumsVM{
  final albumsRepository;

  final Input input;
  late Output output;

  AlbumsVM(this.input, this.albumsRepository) {
    List<int> _firstFavorites = [];
    Stream<AlbumsResponse> albumsData = input.loadData.flatMap((event) {
      return albumsRepository.getFavorites().flatMap((favorites) {
        _firstFavorites.addAll(favorites);
        return albumsRepository.getAlbums();
      });
    });

    Stream<List<int>> favoritesStream = input.toggleFavorite.flatMap((albumId) {
      return albumsRepository.toggleAlbum(albumId);
    });

    Stream<AlbumsResponse> combinedStream = Rx.combineLatest2(
      albumsData, favoritesStream.startWith(_firstFavorites),
      (AlbumsResponse albumsResponse, List<int> favorites) {
        albumsResponse.albums.forEach((album) {
          if (favorites.any((favAlbum) => favAlbum == album.id)) {
            album.favorite = true;
          } else {
            album.favorite = false;
          }
        }
      );
      return albumsResponse;
    });
    output = Output(combinedStream);
  }
}

class Input {
  Subject<bool> loadData;
  Subject<int> toggleFavorite;
  Input(
    this.loadData,
    this.toggleFavorite,
  );
}

class Output {
  final Stream<AlbumsResponse> albumsDataStream;
  Output(
    this.albumsDataStream,
  );
}
