// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';
part 'genre.g.dart';

@Collection()
@Name("Genre")
class Genre {
  Id? id;
  String? title;
  String? url;
  Genre({
    this.id = Isar.autoIncrement,
    this.title,
    this.url,
  });

  Genre copyWith({
    Id? id,
    String? title,
    String? url,
  }) {
    return Genre(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'url': url,
    };
  }

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['id'],
      title: map['title'] != null ? map['title'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Genre.fromJson(String source) =>
      Genre.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Genre(id: $id, title: $title, url: $url)';

  @override
  bool operator ==(covariant Genre other) {
    if (identical(this, other)) return true;

    return other.id == id && other.title == title && other.url == url;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ url.hashCode;
}
