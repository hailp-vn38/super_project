// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import 'package:super_app/models/book.dart';

part 'chapter.g.dart';

@Collection()
@Name("Chapter")
class Chapter {
  Id? id;

  int? index;

  String? name;

  String? url;

  String? dateUpload;

  bool? isBookmarked;

  bool? isRead;

  String? novel;

  List<String>? comic;

  String? movies;
  Chapter({
    this.id = Isar.autoIncrement,
    this.index,
    this.name,
    this.url,
    this.dateUpload,
    this.isBookmarked,
    this.isRead,
    this.novel,
    this.comic,
    this.movies,
  });

  final book = IsarLink<Book>();

  Chapter copyWith({
    Id? id,
    int? index,
    int? bookId,
    String? name,
    String? url,
    String? dateUpload,
    bool? isBookmarked,
    bool? isRead,
    String? novel,
    List<String>? comic,
    String? movies,
  }) {
    return Chapter(
      id: id ?? this.id,
      index: index ?? this.index,
      name: name ?? this.name,
      url: url ?? this.url,
      dateUpload: dateUpload ?? this.dateUpload,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRead: isRead ?? this.isRead,
      novel: novel ?? this.novel,
      comic: comic ?? this.comic,
      movies: movies ?? this.movies,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'index': index,
      'name': name,
      'url': url,
      'dateUpload': dateUpload,
      'isBookmarked': isBookmarked,
      'isRead': isRead,
      'novel': novel,
      'comic': comic,
      'movies': movies,
      'book': book.value
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'],
      index: map['index'],
      name: map['name'] != null ? map['name'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      dateUpload:
          map['dateUpload'] != null ? map['dateUpload'] as String : null,
      isBookmarked:
          map['isBookmarked'] != null ? map['isBookmarked'] as bool : null,
      isRead: map['isRead'] != null ? map['isRead'] as bool : null,
      novel: map['novel'] != null ? map['novel'] as String : null,
      comic: map['comic'],
      movies: map['movies'] != null ? jsonEncode(map['movies']) : null,
    );
  }

  List<Movie>? get getMovies {
    if (movies == null) return null;
    if (jsonDecode(movies!)! is! List) return null;
    return List.from(jsonDecode(movies!)).map((e) => Movie.fromMap(e)).toList();
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  Chapter addContentFromMap(Map<String, dynamic> map) {
    if (map["novel"] != null && map["novel"] is String) {
      novel = map["novel"];
    }
    if (map["comic"] != null && map["comic"] is List<String>) {
      comic = map["comic"];
    }
    if (map["movies"] != null && map["movies"] is List) {
      movies = jsonEncode(map["movies"]);
    }
    if (map["movie"] != null && map["movie"] is List) {
      movies = jsonEncode(map["movie"]);
    }
    return this;
  }

  @override
  String toString() {
    return 'Chapter(id: $id, index: $index, name: $name, url: $url, dateUpload: $dateUpload, isBookmarked: $isBookmarked, isRead: $isRead, novel: $novel, comic: $comic, movies: $movies)';
  }

  @override
  bool operator ==(covariant Chapter other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.index == index &&
        other.name == name &&
        other.url == url &&
        other.dateUpload == dateUpload &&
        other.isBookmarked == isBookmarked &&
        other.isRead == isRead &&
        other.novel == novel &&
        other.comic == comic &&
        other.movies == movies;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        index.hashCode ^
        name.hashCode ^
        url.hashCode ^
        dateUpload.hashCode ^
        isBookmarked.hashCode ^
        isRead.hashCode ^
        novel.hashCode ^
        comic.hashCode ^
        movies.hashCode;
  }
}

class Movie {
  final String? serverName;
  final MovieType type;
  final String data;
  Movie({
    this.serverName,
    required this.type,
    required this.data,
  });

  Movie copyWith({
    String? serverName,
    MovieType? type,
    String? data,
  }) {
    return Movie(
      serverName: serverName ?? this.serverName,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serverName': serverName,
      'type': type.name,
      'data': data,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      serverName:
          map['server_name'] != null ? map['server_name'] as String : null,
      type: MovieType.values.firstWhere(
        (element) => element.name == map['type'],
        orElse: () => MovieType.embed,
      ),
      data: map['data'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) =>
      Movie.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Movie(serverName: $serverName, type: $type, data: $data)';

  @override
  bool operator ==(covariant Movie other) {
    if (identical(this, other)) return true;

    return other.serverName == serverName &&
        other.type == type &&
        other.data == data;
  }

  @override
  int get hashCode => serverName.hashCode ^ type.hashCode ^ data.hashCode;
}

enum MovieType { embed, file, iframe }
