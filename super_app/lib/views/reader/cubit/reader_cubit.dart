import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:js_runtime/utils/logger.dart';
import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/app/mixins/state.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/utils/device_utils.dart';

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
            trackRead: args.track,
            chapters: args.chapters ?? [],
            loadExtensionErr: false,
            readCurrentChapter: const StateRes(
              status: StatusType.init,
            )));

  final _logger = Logger("ReaderCubit");

  final DatabaseService _databaseService;
  final JsRuntime _jsRuntime;

  List<Chapter> get getChapters => state.chapters;
  TrackRead get getTrackRead => state.trackRead;
  Chapter get getCurrentChapter => state.readCurrentChapter.data!;

  Extension? extension;
  Book? book;

  Timer? _timerTrackReader;

  ReaderArgs args;

  void onInit() async {
    book = args.book;
    await getExtension();
    if (extension == null) return;
    if (getTrackRead.indexChapter != null &&
        getTrackRead.indexChapter! > getChapters.length) {
      emit(state.copyWith(loadExtensionErr: true));
      return;
    }
    _logger.log(
        " Book :\n id = ${book?.id}\n name = ${book?.name}\n chapters = ${getChapters.length} \n reader index = ${state.trackRead.indexChapter}",
        name: "onInit");

    getDetailChapter(getChapters[getTrackRead.indexChapter ?? 0]);
  }

  Future<void> getExtension() async {
    if (args.extension == null) {
      final ext =
          await _databaseService.getExtensionByName(args.book.extensionName!);
      if (ext == null) {
        emit(state.copyWith(loadExtensionErr: true));
        return;
      }
      args = args.copyWith(extension: ext);
    }
    extension = args.extension!;
    if (book?.id == null) {
      final chapters =
          state.chapters.sorted((a, b) => a.index!.compareTo(b.index!));
      emit(state.copyWith(
          chapters: chapters,
          readCurrentChapter: StateRes(
              status: StatusType.init,
              data: chapters[args.track.indexChapter!])));
    } else {
      final chapters = await _databaseService.getChaptersByBookId(book!.id!);
      emit(state.copyWith(
          chapters: chapters,
          readCurrentChapter: StateRes(
              status: StatusType.init,
              data: chapters[args.track.indexChapter!])));
    }
  }

  void update({required Chapter current, required Chapter next}) {
    current.offset = state.trackRead.offset;
    final track = state.trackRead.copyWith(
        offset: next.offset,
        currentChapterName: next.name,
        chapterId: next.id,
        indexChapter: next.index);

    if (book?.id != null) {
      book!.updateAt = DateTime.now();
      _databaseService.updateTrackRead(track);
    }
    List<Chapter> chapters = getChapters;
    chapters[current.index!] = current;

    emit(state.copyWith(
        chapters: chapters,
        trackRead: track,
        readCurrentChapter: StateRes(status: StatusType.init, data: next)));
    getDetailChapter(next);
  }

  bool perChapter() {
    final currentIndex = state.readCurrentChapter.data!.index!;
    if (currentIndex == 0) return false;

    final perChapter = getChapters[currentIndex - 1];
    update(current: state.readCurrentChapter.data!, next: perChapter);
    return true;
  }

  bool nextChapter() {
    final currentIndex = state.readCurrentChapter.data!.index!;
    if (currentIndex + 1 >= getChapters.length) return false;
    final nextChapter = getChapters[currentIndex + 1];
    update(current: state.readCurrentChapter.data!, next: nextChapter);
    return true;
  }

  void onChangeChapter(Chapter chapter) {
    update(current: state.readCurrentChapter.data!, next: chapter);
  }

  Future<Chapter> getChapterByType(
      {required Chapter chapter, required ExtensionType type}) async {
    if (chapter.comic != null ||
        chapter.movies != null ||
        chapter.novel != null) {
      return chapter;
    }

    final res = await _jsRuntime.getChapter(
        url: chapter.url!.replaceUrl(args.extension!.source),
        jsScript: args.extension!.getChapterScript);

    if (res != null) {
      chapter.addContentFromMap({type.name: res});
    }

    return chapter;
  }

  void getDetailChapter(Chapter chapter) async {
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

  void updateScrollReader({required double offset, required int percent}) {
    emit(state.copyWith(
        trackRead: state.trackRead.copyWith(offset: offset, percent: percent)));

    if (state.trackRead.chapterId == null) return;

    if (_timerTrackReader != null && _timerTrackReader!.isActive) {
      _timerTrackReader!.cancel();
    }

    _timerTrackReader = Timer(const Duration(seconds: 3), () async {
      await _databaseService.updateTrackRead(state.trackRead);
    });
  }

  ({int currentPage, int totalPage, int percent}) getProgressScroll(
      double offset, double maxScrollExtent, double height) {
    if (maxScrollExtent == 0.0 || offset == 0.0) {
      return (currentPage: 0, totalPage: 0, percent: 0);
    }
    final totalPage = (maxScrollExtent ~/ height) + 1;
    final currentPage = (offset ~/ height) + 1;
    final percent = ((currentPage / totalPage) * 100).clamp(0, 100).toInt();

    return (currentPage: currentPage, totalPage: totalPage, percent: percent);
  }

  @override
  Future<void> close() {
    DeviceUtils.setOrientationPortrait();
    _timerTrackReader?.cancel();
    return super.close();
  }
}
