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
        super(const ReaderState());

  final _logger = Logger("ReaderCubit");

  final DatabaseService _databaseService;
  final JsRuntime _jsRuntime;
  ReaderArgs args;
  void onInit() {
    getExtension();
  }

  Future<void> getExtension() async {
    args = args.copyWith(
        chapters: args.chapters.sorted((a, b) => a.index!.compareTo(b.index!)));
    if (args.extension == null) {
      final ext =
          await _databaseService.getExtensionBySource(args.book.getSource);
      args = args.copyWith(extension: ext);
      // Err k co extension duoc cai dat
    }
  }

  String url() {
    final movie = args.chapters.first.getMovies!.first;

    return movie.data;
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

    if (res != null && res is Map) {
      chapter.addContentFromMap({type.name: res});
    }

    return chapter;
  }

  Future<bool> refreshChapters() async {
    try {
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
      if(chapters.isEmpty){

      }else{
        
      }
    } catch (err) {
      //
    }
    return true;
  }
}
