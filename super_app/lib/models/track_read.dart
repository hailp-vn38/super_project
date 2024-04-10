// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:isar/isar.dart';

part 'track_read.g.dart';

@Collection()
@Name("TrackRead")
class TrackRead {
  Id? id;
  int? indexChapter;
  int? chapterId;
  int? bookId;
  double? offset;
  String? currentChapterName;
  String? lastChapterName;
  int? percent;
  int? totalPage;
  int? currentPage;

  TrackRead(
      {this.id = Isar.autoIncrement,
      this.indexChapter,
      this.chapterId,
      this.bookId,
      this.lastChapterName,
      this.offset,
      this.currentChapterName,
      this.percent,
      this.currentPage,
      this.totalPage});

  TrackRead copyWith({
    Id? id,
    int? indexChapter,
    int? chapterId,
    double? offset,
    String? currentChapterName,
    int? percent,
    int? totalPage,
    int? currentPage,
  }) {
    return TrackRead(
        id: id ?? this.id,
        indexChapter: indexChapter ?? this.indexChapter,
        chapterId: chapterId ?? this.chapterId,
        offset: offset ?? this.offset,
        currentChapterName: currentChapterName ?? this.currentChapterName,
        percent: percent ?? this.percent,
        totalPage: totalPage ?? this.totalPage,
        currentPage: currentPage ?? this.currentPage);
  }
}
