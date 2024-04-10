// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:js_runtime/utils/logger.dart';

import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit(
      {required DatabaseService databaseService,
      required JsRuntime jsRuntime,
      required this.bookUrl})
      : _databaseService = databaseService,
        _jsRuntime = jsRuntime,
        super(const DetailState(
            bookState: StateRes(status: StatusType.init),
            chaptersState: StateRes(status: StatusType.init),
            genresState: StateRes(status: StatusType.init)));

  final _logger = Logger("DetailBookCubit");

  final DatabaseService _databaseService;
  Extension? _extension;
  final JsRuntime _jsRuntime;
  final String bookUrl;

  StateRes<Book> get bookState => state.bookState;
  StateRes<List<Chapter>> get chaptersState => state.chaptersState;

  Extension? get getExtension => _extension;

  Completer<({Book book, List<Chapter> chapters, List<Genre> genres})>?
      detailCompleter;

  void onInit() async {
    DetailState detailState = state;

    try {
      final hostBook = bookUrl.getHostByUrl;

      if (hostBook == null) {
        emit(detailState.copyWith(
            bookState: bookState.copyWith(
                status: StatusType.error, message: "Book url error")));

        return;
      }
      _extension = await _databaseService.getExtensionBySource(hostBook);
      if (_extension == null) {
        emit(detailState.copyWith(
            bookState: bookState.copyWith(
                status: StatusType.error, message: "Extension not found")));
        return;
      }

      detailState = detailState.copyWith(
          bookState: const StateRes(status: StatusType.loading));
      // emit loading detail book
      emit(detailState);
      _logger.info("", name: "init");
      getDetailBook().then((detail) {
        detailState = detailState.copyWith(
            bookState: StateRes(status: StatusType.loaded, data: detail.book),
            chaptersState: detail.chapters.isNotEmpty
                ? StateRes(status: StatusType.loaded, data: detail.chapters)
                : null,
            genresState: detail.genres.isNotEmpty
                ? StateRes(status: StatusType.loaded, data: detail.genres)
                : null);
        if (detail.chapters.isEmpty) {
          _getChapters();
        }
        // emit data detail
        emit(detailState);
      }).catchError((err) {
        emit(detailState.copyWith(
            bookState: const StateRes(
          status: StatusType.error,
        )));
      });
    } catch (err) {
      emit(detailState.copyWith(
          bookState: bookState.copyWith(
              status: StatusType.error, message: "Extension not found")));
    }
  }

  Future<void> _getChapters() async {
    emit(state.copyWith(
        chaptersState: chaptersState.copyWith(status: StatusType.loading)));
    try {
      final result = await _jsRuntime.getChapters<List<dynamic>>(
          url: bookUrl, jsScript: _extension!.getChaptersScript);
      List<Chapter> chapters = [];
      for (var i = 0; i < result.length; i++) {
        final map = result[i];
        if (map is Map<String, dynamic>) {
          chapters.add(Chapter.fromMap({...map, "index": i}));
        }
      }
      emit(state.copyWith(
          chaptersState: chaptersState.copyWith(
              status: StatusType.loaded, data: chapters)));
    } on JsRuntimeException catch (error) {
      _logger.log(error.message);
    } catch (error) {
      if (isClosed) return;
      emit(state.copyWith(
          chaptersState: chaptersState.copyWith(
              status: StatusType.error, message: "Error get data book")));
    }
  }

  void reverseChapters() {
    emit(state.copyWith(
        chaptersState: chaptersState.copyWith(
            data: chaptersState.data!.reversed.toList())));
  }

  Future<void> onRefreshDetail() async {
    try {
      _logger.info("", name: "onRefreshDetail");
      final detail = await getDetailBook();
      DetailState state = this.state;
      state = state.copyWith(
          bookState: StateRes(status: StatusType.loaded, data: detail.book),
          chaptersState: detail.chapters.isNotEmpty
              ? StateRes(status: StatusType.loaded, data: detail.chapters)
              : null,
          genresState: detail.genres.isNotEmpty
              ? StateRes(status: StatusType.loaded, data: detail.genres)
              : null);
      if (detail.chapters.isEmpty) {
        _getChapters();
      }
      emit(state);
    } catch (err) {
      _logger.error(err, name: "onRefreshDetail");
    }
  }

  Future<({Book book, List<Chapter> chapters, List<Genre> genres})>
      getDetailBook() async {
    final jsCore = await rootBundle.loadString("assets/js/extension.js");
    return compute(computeFunGetDetail,
        JsRuntimePrams(jsCore: jsCore, url: bookUrl, extension: _extension!));
  }

  String get titleChaptersByType {
    return switch (_extension!.metadata.type!) {
      ExtensionType.comic => "comic",
      ExtensionType.novel => "novel",
      ExtensionType.movie => "movie",
      ExtensionType.all => "all",
    };
  }

  Future<bool> addLibrary() async {
    try {
      Book book = bookState.data!;
      book.chapters.addAll(chaptersState.data ?? []);
      book.genres.addAll(state.genresState.data ?? []);
      final chapter = chaptersState.data!.first;
      book.trackRead.value = TrackRead(
        indexChapter: chapter.index,
        currentChapterName: chapter.name,
        offset: 0.0,
        percent: 0,
      );
      book.updateAt = DateTime.now();
      final bookLibrary = await _databaseService.insertBook(book);
      if (bookLibrary == null) return false;

      final chapters = bookLibrary.chapters
          .toList()
          .sorted((a, b) => a.index!.compareTo(b.index!));
      _databaseService.updateTrackRead(
          bookLibrary.trackRead.value!.copyWith(chapterId: chapters.first.id));

      emit(DetailState(
          bookState: StateRes(status: StatusType.loaded, data: bookLibrary),
          chaptersState: StateRes(status: StatusType.loaded, data: chapters),
          genresState: StateRes(
              status: StatusType.loaded, data: bookLibrary.genres.toList())));
      _logger.error("add success bookId : ${bookLibrary.id}",
          name: "addLibrary");
      return true;
    } catch (err) {
      _logger.error(err, name: "addLibrary");
      return false;
    }
  }
}

class JsRuntimePrams {
  final String jsCore;
  final String url;
  final Extension extension;
  JsRuntimePrams(
      {required this.jsCore, required this.url, required this.extension});
}

Future<({Book book, List<Chapter> chapters, List<Genre> genres})>
    computeFunGetDetail(JsRuntimePrams prams) async {
  try {
    final jsRuntime = JsRuntime();
    final isReady = await jsRuntime.initRuntimeTst(jsExtension: prams.jsCore);

    if (!isReady) return Future.error(Exception("jsRuntime init Error"));
    List<Chapter> chapters = [];
    List<Genre> genres = [];
    final result = await jsRuntime.getDetail<Map<String, dynamic>>(
      url: prams.url,
      jsScript: prams.extension.getDetailScript,
    );
    Book book =
        Book.fromMap({...result, "type": prams.extension.metadata.type});
    Uri bookUri = Uri.parse(book.url!);
    // Kiểm tra xem book url đã có url hợp kệ hay chưa
    if (!bookUri.isScheme("HTTP")) {
      final uriExt = Uri.parse(prams.extension.metadata.source!);
      bookUri = bookUri.replace(scheme: uriExt.scheme, host: uriExt.host);

      book.url = bookUri.toString();
    }
    if (result["genres"] != null && result["genres"] is List) {
      genres =
          List.from(result["genres"]).map((e) => Genre.fromMap(e)).toList();
    }

    if (result["chapters"] != null &&
        result["chapters"] is List &&
        result["chapters"].length > 0) {
      for (var i = 0; i < result["chapters"].length; i++) {
        final map = result["chapters"][i];
        if (map is Map<String, dynamic>) {
          chapters.add(Chapter.fromMap({...map, "index": i}));
        }
      }
    }

    return (book: book, chapters: chapters, genres: genres);
  } catch (err) {
    return Future.error(Exception("jsRuntime init Error"));
  }
}
