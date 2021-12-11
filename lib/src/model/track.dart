
import 'dart:convert';
import 'dart:typed_data';

class Track {

  final String? id;
  final String? title;
  final String? subtitle;
  final String? artist;
  final String? composer;
  final String? album;
  final String? albumArtist;
  final num? duration;
  final Uint8List? art;
  Track({
    this.id,
    this.title,
    this.subtitle,
    this.artist,
    this.composer,
    this.album,
    this.albumArtist,
    this.duration,
    this.art,
  });

  //   Track(){
  //   }

  //   public Track withid(String id){
  //       this.id = id;
  //       return this;
  //   }
  //   public Track withttitle(String title){
  //       this.title = title;
  //       return this;
  //   }
  //   public Track withsubtitle(String title){
  //       this.subtitle = title;
  //       return this;
  //   }
  //   public  Track withartist(String artist){
  //       this.artist = artist;
  //       return this;
  //   }
  //   public Track withcomposer(String composer){
  //       this.composer = composer;
  //       return this;
  //   }
  //   public  Track withalbum(String album){
  //       this.album = album;
  //       return this;
  //   }
  //   public  Track withalbumArtist(String albumArtist){
  //       this.albumArtist = albumArtist;
  //       return this;
  //   }
  //   public Track withduration(long duration){
  //       this.duration = duration;
  //       return this;
  //   }
  //   public Track withart(Bitmap art){
  //       this.art = art;
  //       return this;
  //   }


  //   HashMap<String,Object> toJson(){
  //   HashMap<String,Object> map = new HashMap<>();
  //  if(id !=null)
  //                  map.put("id", id );
  //                  if(title !=null)
  //                  map.put("title", title );
  //                  if(subtitle !=null)
  //                  map.put("subtitle", subtitle );
  //                  if(artist !=null)
  //                  map.put("artist", artist );
  //                  if(composer !=null)
  //                  map.put("composer", composer );
  //                  if(album !=null)
  //                  map.put("album", album );
  //                  if(albumArtist !=null)
  //                  map.put("albumArtist", albumArtist );
  //                  if( duration > 0)
  //                  map.put("duration", duration );

  //   return map;
  //   };


  Track copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? artist,
    String? composer,
    String? album,
    String? albumArtist,
    num? duration,
    Uint8List? art,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      artist: artist ?? this.artist,
      composer: composer ?? this.composer,
      album: album ?? this.album,
      albumArtist: albumArtist ?? this.albumArtist,
      duration: duration ?? this.duration,
      art: art ?? this.art,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'artist': artist,
      'composer': composer,
      'album': album,
      'albumArtist': albumArtist,
      'duration': duration,
      'art': art,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      artist: map['artist'],
      composer: map['composer'],
      album: map['album'],
      albumArtist: map['albumArtist'],
      duration: map['duration'],
      art: map['art'] != null ? Uint8List.fromList(map['art']) : null,
    );
  }

  // String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) => Track.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Track(id: $id, title: $title, )'; //subtitle: $subtitle, artist: $artist, composer: $composer, album: $album, albumArtist: $albumArtist, duration: $duration, art: $art
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Track &&
      other.id == id &&
      other.title == title &&
      other.subtitle == subtitle &&
      other.artist == artist &&
      other.composer == composer &&
      other.album == album &&
      other.albumArtist == albumArtist &&
      other.duration == duration &&
      other.art == art;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      artist.hashCode ^
      composer.hashCode ^
      album.hashCode ^
      albumArtist.hashCode ^
      duration.hashCode ^
      art.hashCode;
  }
}

