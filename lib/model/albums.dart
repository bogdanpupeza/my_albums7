class Album{
  final int? userId;
  final String? name;
  final int id;
  bool? favorite;
  Album({
    required this.userId,
    required this.name,
    required this.id,
    this.favorite = false,
  });
  
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int,
      name: json['title'] as String?,
      userId: json['userId'] as int?,
      favorite: json['favoriteStatus'] as bool?,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "title": name,
      "userId": userId,
      "favoriteStatus": favorite,
    };
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator == (Object other) =>
    other is Album &&
    other.favorite == favorite &&
    other.id == id &&
    other.userId == userId &&
    other.name == name;
}

class AlbumsResponse{
  final List<Album> albums;
  DateTime? lastUpdate;
  AlbumsResponse({
    required this.albums,
    required this.lastUpdate,
  });
  factory AlbumsResponse.fromAlbums(albums, date){
    return AlbumsResponse(
      albums: albums,
      lastUpdate: date,
    );
  }
}
