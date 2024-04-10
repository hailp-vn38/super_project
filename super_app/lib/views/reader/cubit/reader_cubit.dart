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
            chapters: args.chapters,
            trackRead: args.track,
            loadExtensionErr: false,
            readCurrentChapter: StateRes(
                status: StatusType.init,
                data: args.chapters[args.track.indexChapter ?? 0])));

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

  @override
  void onChange(Change<ReaderState> change) {
    super.onChange(change);

    // Kiểm tra thay đổi chapter
    // + up offset của track read hiện tại vào chapter củ
    // + up thông tin chapter mới vào track read : index,chapterId,offset
    final current = change.currentState;
    final next = change.nextState;
    if (book!.id == null) return;
    if (current.readCurrentChapter.data != null &&
        next.readCurrentChapter.data != null &&
        current.readCurrentChapter.data!.index !=
            next.readCurrentChapter.data!.index) {
      final currentChapter = current.readCurrentChapter.data!
          .copyWith(offset: getTrackRead.offset);
      final nextChapter = next.readCurrentChapter.data!;

      final track = next.trackRead.copyWith(
          offset: nextChapter.offset,
          currentChapterName: nextChapter.name,
          chapterId: nextChapter.id,
          indexChapter: nextChapter.index);

      emit(state.copyWith(trackRead: track));

      book!.updateAt = DateTime.now();

      _databaseService.updateBookData(
          book: book!, trackRead: track, chapter: currentChapter);
      updateChapterInChapters(currentChapter);

      _logger.log("change chapter ${state.trackRead.indexChapter}",
          name: "onChange");
    }
  }

  void onInit() async {
    book = args.book;

    await getExtension();
    if (extension == null) return;
    if (getTrackRead.indexChapter != null &&
        getTrackRead.indexChapter! > getChapters.length) {
      emit(state.copyWith(loadExtensionErr: true));
      return;
    }
    final chapters = getChapters.sorted((a, b) => a.index!.compareTo(b.index!));

    emit(state.copyWith(chapters: chapters));

    _logger.log("chapter index : ${getTrackRead.indexChapter}", name: "onInit");

    getDetailChapter(getChapters[getTrackRead.indexChapter ?? 0]);
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
    _logger.log("chapter index : ${chapter.index}", name: "getDetailChapter");

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

  void updateChapterInChapters(Chapter chapter) {
    List<Chapter> chapters = getChapters;
    chapters[chapter.index!] = chapter;
    emit(state.copyWith(chapters: chapters));
    _logger.info("index chapter :${chapter.index}",
        name: "updateChapterInChapters");
  }

  @override
  Future<void> close() {
    DeviceUtils.setOrientationPortrait();
    _timerTrackReader?.cancel();
    return super.close();
  }
}
