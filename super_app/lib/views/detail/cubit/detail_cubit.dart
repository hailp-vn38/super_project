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
    try {
      final hostBook = bookUrl.getHostByUrl;
      if (hostBook == null) {
        emit(state.copyWith(
            bookState: bookState.copyWith(
                status: StatusType.error, message: "Book url error")));

        return;
      }
      _extension = await _databaseService.getExtensionBySource(hostBook);
      if (_extension == null) {
        emit(state.copyWith(
            bookState: bookState.copyWith(
                status: StatusType.error, message: "Extension not found")));
        return;
      }
      _getDetailBook().then((value) {
        if (bookState.status == StatusType.loaded &&
            chaptersState.status == StatusType.init) {
          _getChapters();
        }
      });
    } catch (err) {
      emit(state.copyWith(
          bookState: bookState.copyWith(
              status: StatusType.error, message: "Extension not found")));
    }
  }

  Future<void> _getDetailBook() async {
    try {
      emit(state.copyWith(
          bookState: bookState.copyWith(status: StatusType.loading)));
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

      DetailState stateCurrent = state;

      stateCurrent = stateCurrent.copyWith(
          bookState: bookState.copyWith(status: StatusType.loaded, data: book));
      if (result["genres"] != null && result["genres"] is List) {
        final genres =
            List.from(result["genres"]).map((e) => Genre.fromMap(e)).toList();
        stateCurrent = stateCurrent.copyWith(
            genresState: StateRes(status: StatusType.loaded, data: genres));
      }

      if (result["chapters"] != null &&
          result["chapters"] is List &&
          result["chapters"].length > 0) {
        List<Chapter> chapters = [];
        for (var i = 0; i < result["chapters"].length; i++) {
          final map = result["chapters"][i];
          if (map is Map<String, dynamic>) {
            chapters.add(Chapter.fromMap({...map, "index": i}));
          }
        }
        // final chapters = List.from()
        //     .map((e) => Chapter.fromMap(e))
        //     .toList();
        stateCurrent = stateCurrent.copyWith(
            chaptersState: StateRes(status: StatusType.loaded, data: chapters));
      }

      final bookInBookmark = await _databaseService.getBookByUrl(book.url!);
      // if (bookInBookmark != null) {
      //   book = bookInBookmark.copyWith(
      //     totalChapters: book.totalChapters,
      //   );
      // }
      emit(stateCurrent);
    } catch (error) {
      _logger.error(error, name: "getDetailBook");
      emit(state.copyWith(
          bookState: bookState.copyWith(
              status: StatusType.error, message: "Error get data book")));
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
}
