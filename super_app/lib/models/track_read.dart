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
  int? totalChapter;
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
      this.totalChapter,
      this.currentChapterName,
      this.percent,
      this.currentPage,
      this.totalPage});

  TrackRead copyWith({
    Id? id,
    int? indexChapter,
    int? chapterId,
    double? offset,
    int? totalChapter,
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
        totalChapter: totalChapter ?? this.totalChapter,
        currentChapterName: currentChapterName ?? this.currentChapterName,
        percent: percent ?? this.percent,
        totalPage: totalPage ?? this.totalPage,
        currentPage: currentPage ?? this.currentPage);
  }

  @override
  bool operator ==(covariant TrackRead other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.indexChapter == indexChapter &&
        other.chapterId == chapterId &&
        other.bookId == bookId &&
        other.offset == offset &&
        other.currentChapterName == currentChapterName &&
        other.lastChapterName == lastChapterName &&
        other.totalChapter == totalChapter &&
        other.percent == percent &&
        other.totalPage == totalPage &&
        other.currentPage == currentPage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        indexChapter.hashCode ^
        chapterId.hashCode ^
        bookId.hashCode ^
        offset.hashCode ^
        currentChapterName.hashCode ^
        lastChapterName.hashCode ^
        totalChapter.hashCode ^
        percent.hashCode ^
        totalPage.hashCode ^
        currentPage.hashCode;
  }

  @override
  String toString() {
    return 'TrackRead(id: $id, indexChapter: $indexChapter, chapterId: $chapterId, bookId: $bookId, offset: $offset, currentChapterName: $currentChapterName, lastChapterName: $lastChapterName, totalChapter: $totalChapter, percent: $percent, totalPage: $totalPage, currentPage: $currentPage)';
  }
}
