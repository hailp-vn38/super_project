import 'package:equatable/equatable.dart';
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
      _logger.info("", name: "onRefreshDetail");
      final detail = await getDetailBook();
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
    try {
      List<Chapter> chapters = [];
      List<Genre> genres = [];
      final result = await _jsRuntime.getDetail<Map<String, dynamic>>(
        url: bookUrl,
        jsScript: _extension!.getDetailScript,
      );
      Book book = Book.fromMap({...result, "type": _extension!.metadata.type});
      Uri bookUri = Uri.parse(book.url!);
      if (!bookUri.isScheme("HTTP")) {
        final uriExt = Uri.parse(_extension!.metadata.source!);
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
      _logger.info(
          "\nSTART\n Book : ${book.name}\n Chapters : ${chapters.length} \n Genres : ${genres.length}\nEND",
          name: "getDetailBook");
      return (book: book, chapters: chapters, genres: genres);
    } catch (error) {
      _logger.log(error, name: "getDetailBook");
      rethrow;
    }
  }
}
