import 'package:rxdart/rxdart.dart';
import '../model/albums_cache.dart';
import '../model/albums.dart';
import '../model/albums_repository.dart';
import '../model/albums_service.dart';

class AlbumsVM{
  final albumsRepository = AlbumsRepository(AlbumsService(),AlbumsCache());
  final Input input;
  late Output output;
  
  AlbumsVM(this.input){
    List<int> _firstFavorites = [];
    Stream<AlbumsResponse> albumsData = input.loadData.flatMap(
      (event){
        return albumsRepository.getFavorites().flatMap((favorites){
          _firstFavorites.addAll(favorites);
          return albumsRepository.getAlbums();
        });
      }
    );
    
    Stream<List<int>> favoritesStream = input.toggleFavorite.flatMap((albumId){
      return albumsRepository.toggleAlbum(albumId);
    });

    Stream<AlbumsResponse> combinedStream =
    Rx.combineLatest2(albumsData, favoritesStream.startWith(_firstFavorites), 
      (AlbumsResponse albumsResponse, List<int> favorites){
        albumsResponse.albums.forEach((album){
          if (favorites.any((favAlbum) => favAlbum == album.id)){
            album.favorite = true;
          } else {
            album.favorite = false;
          }
        });
        return albumsResponse;
      }
    );
    output = Output(combinedStream);
  }
}

class Input{
  Subject<bool> loadData;
  Subject<int> toggleFavorite;
  Input(
    this.loadData,
    this.toggleFavorite,
  );
}

class Output{
  final Stream<AlbumsResponse> albumsDataStream;
  Output(
    this.albumsDataStream,
  );
}