// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:super_app/models/book.dart';
part 'track_read.g.dart';

@Collection()
@Name("TrackRead")
class TrackRead {
  Id? id;
  int? readCurrentChapter;
  TrackRead({
    this.id = Isar.autoIncrement,
    this.readCurrentChapter,
  });

  final book = IsarLink<Book>();
}
