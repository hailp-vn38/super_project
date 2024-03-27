import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:js_runtime/utils/logger.dart';
import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';

import '../view/reader_view.dart';

part 'reader_state.dart';

class ReaderCubit extends Cubit<ReaderState> {
  ReaderCubit({
    required DatabaseService databaseService,
    required JsRuntime jsRuntime,
    required this.args,
  })  : _databaseService = databaseService,
        _jsRuntime = jsRuntime,
        super(ReaderState(
            chapters: args.chapters,
            trackRead: args.track,
            loadExtensionErr: false,
            readCurrentChapter: StateRes(
                status: StatusType.init,
                data: args.chapters[args.track.readCurrentChapter ?? 0])));

  final _logger = Logger("ReaderCubit");

  final DatabaseService _databaseService;
  final JsRuntime _jsRuntime;

  List<Chapter> get getChapters => state.chapters;
  TrackRead get getTrackRead => state.trackRead;

  Extension? extension;
  Book? book;

  ReaderArgs args;
  void onInit() async {
    book = args.book;

    await getExtension();
    if (extension == null) return;
    if (getTrackRead.readCurrentChapter != null &&
        getTrackRead.readCurrentChapter! > getChapters.length) {
      emit(state.copyWith(loadExtensionErr: true));
      return;
    }
    getDetailChapter(getChapters[getTrackRead.readCurrentChapter!]);
  }

  Future<void> getExtension() async {
    args = args.copyWith(
        chapters: args.chapters.sorted((a, b) => a.index!.compareTo(b.index!)));
    if (args.extension == null) {
      final ext =
          await _databaseService.getExtensionBySource(args.book.getSource);
      if (ext == null) {
        emit(state.copyWith(loadExtensionErr: true));
        return;
      }
      args = args.copyWith(extension: ext);
    }
    extension = args.extension!;
  }

  Future<Chapter> getChapterByType(
      {required Chapter chapter, required ExtensionType type}) async {
    if (chapter.comic != null ||
        chapter.movies != null ||
        chapter.comic != null) {
      return chapter;
    }

    final res = await _jsRuntime.getChapter(
        url: chapter.url!.replaceUrl(args.extension!.source),
        jsScript: args.extension!.getChapterScript);

    if (res != null) {
      chapter.addContentFromMap({type.name: res});
    }

    // _logger.info("chapterId : ${chapter.id}", name: "getChapterByType");

    return chapter;
  }

  void getDetailChapter(Chapter chapter) async {
    _logger.info("chapterId : ${chapter.id}", name: "getDetailChapter");

    try {
      emit(state.copyWith(
          loadExtensionErr: false,
          readCurrentChapter:
              StateRes(status: StatusType.loading, data: chapter)));
      chapter = await getChapterByType(
          chapter: chapter, type: extension!.metadata.type!);

      bool isError = false;
      switch (book!.type!) {
        case ExtensionType.comic:
          if (chapter.comic == null) {
            isError = true;
          }
          break;
        case ExtensionType.movie:
          if (chapter.movies == null) {
            isError = true;
          }

          break;
        case ExtensionType.novel:
          if (chapter.novel == null) {
            isError = true;
          }
          break;
        default:
          isError = false;
      }
      if (isError) {
        emit(state.copyWith(
            readCurrentChapter: StateRes(
                status: StatusType.error,
                data: chapter,
                message: "Lỗi lấy dữ liệu")));
      } else {
        emit(state.copyWith(
            readCurrentChapter: StateRes(
          status: StatusType.loaded,
          data: chapter,
        )));
      }
    } catch (err) {
      emit(state.copyWith(
          readCurrentChapter: StateRes(
              status: StatusType.error,
              data: chapter,
              message: "load chapter err")));
    }
  }

  Future<bool> refreshChapters() async {
    try {
      _logger.info("[]", name: "refreshChapters");

      final res = await _jsRuntime.getChapters(
          url: args.book.url!.replaceUrl(args.extension!.source),
          jsScript: args.extension!.getChaptersScript);
      List<Chapter> chapters = [];
      for (var i = 0; i < res.length; i++) {
        final map = res[i];
        if (map is Map<String, dynamic>) {
          chapters.add(Chapter.fromMap({...map, "index": i}));
        }
      }
      if (chapters.isEmpty) {
      } else {}
    } catch (err) {
      //
    }
    return true;
  }

  void updateTrackRead(TrackRead trackRead) {
    emit(state.copyWith(trackRead: trackRead));
  }
}
