class Music {
  final String id;
  final String title;
  final String artist;
  final String genre;
  final int year;
  final String albumArt;
  final String audioUrl;

  Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.year,
    required this.albumArt,
    required this.audioUrl,
  });

  Music copyWith({
    String? id,
    String? title,
    String? artist,
    String? genre,
    int? year,
    String? audioUrl,
    String? albumArt,
  }) =>
      Music(
        id: id ?? this.id,
        title: title ?? this.title,
        artist: artist ?? this.artist,
        genre: genre ?? this.genre,
        year: year ?? this.year,
        audioUrl: audioUrl ?? this.audioUrl,
        albumArt: albumArt ?? this.albumArt,
      );

  factory Music.fromJson(Map<String, dynamic> json) => Music(
        id: json["id"],
        title: json["title"],
        artist: json["artist"],
        genre: json["genre"],
        year: json["year"],
        audioUrl: json["audioURL"],
        albumArt: json["albumArt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "artist": artist,
        "genre": genre,
        "year": year,
        "audioURL": audioUrl,
        "albumArt": albumArt,
      };
}
