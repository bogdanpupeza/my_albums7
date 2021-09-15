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
    Stream<AlbumsResponse> albumsData = input.loadData.flatMap(
      (event){
        return albumsRepository.getAlbums();
      }
    );
    
    Stream<List<int>> favoritesStream = input.toggleFavorite.flatMap((albumId){
      return albumsRepository.toggleAlbum(albumId);
    });

    Stream<AlbumsResponse> combinedStream =
    Rx.combineLatest2(albumsData, favoritesStream.startWith([]), 
      (AlbumsResponse albumsResponse, List<int> favorites){
        return AlbumsResponse(
          albums: albumsResponse.albums.map((album){
            Album albumFav = Album(
              id: album.id,
              name: album.name,
              userId: album.userId,
              favorite: favorites.any((element) => element == album.id),
            );
            return albumFav;
          }).toList(), 
          lastUpdate: albumsResponse.lastUpdate
         );
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