// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'reader_cubit.dart';

class ReaderState extends Equatable {
  const ReaderState(
      {required this.trackRead,
      required this.chapters,
      required this.readCurrentChapter,
      required this.loadExtensionErr});
  final List<Chapter> chapters;
  final TrackRead trackRead;
  final StateRes<Chapter> readCurrentChapter;
  final bool loadExtensionErr;

  @override
  List<Object> get props =>
      [chapters, trackRead, readCurrentChapter, loadExtensionErr];

  ReaderState copyWith(
      {List<Chapter>? chapters,
      TrackRead? trackRead,
      StateRes<Chapter>? readCurrentChapter,
      bool? loadExtensionErr}) {
    return ReaderState(
        chapters: chapters ?? this.chapters,
        trackRead: trackRead ?? this.trackRead,
        readCurrentChapter: readCurrentChapter ?? this.readCurrentChapter,
        loadExtensionErr: loadExtensionErr ?? this.loadExtensionErr);
  }
}

