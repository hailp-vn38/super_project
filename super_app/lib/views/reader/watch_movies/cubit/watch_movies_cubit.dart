import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/views/reader/cubit/reader_cubit.dart';

part 'watch_movies_state.dart';

class WatchMoviesCubit extends Cubit<WatchMoviesState> {
  WatchMoviesCubit({required this.readerCubit})
      : super(const WatchMoviesState(
            currentWatch: StateRes(status: StatusType.init)));

  final ReaderCubit readerCubit;

  Book get getBook => readerCubit.args.book;

  List<Chapter> get getChapters => readerCubit.args.chapters;
  void onInit() async {
    Chapter currentChapter =
        getChapters[readerCubit.args.track.readCurrentChapter ?? 0];
    getChapter(currentChapter);
  }

  Webview? _webviewDesktop;

  void getChapter(Chapter chapter) async {
    try {
      emit(WatchMoviesState(
          currentWatch: StateRes(status: StatusType.loading, data: chapter)));
      // await Future.delayed(Duration(seconds: 1));
      chapter = await readerCubit.getChapterByType(
          chapter: chapter, type: getBook.type!);
      if (chapter.getMovies == null || chapter.getMovies!.isEmpty) {
        emit(state.copyWith(
            currentWatch: StateRes(
                status: StatusType.error,
                data: chapter,
                message: "Lỗi lấy dữ liệu")));
      } else {
        emit(WatchMoviesState(
            movie: chapter.getMovies!.first,
            currentWatch: StateRes(
              status: StatusType.loaded,
              data: chapter,
            )));
      }
    } catch (err) {
      emit(state.copyWith(
          currentWatch: StateRes(
              status: StatusType.error,
              data: chapter,
              message: "load chapter err")));
    }
  }

  void onChangeChapter(Chapter chapter) {
    getChapter(chapter);
  }

  void onChangeServer(Movie movie) {
    emit(state.copyWith(movie: movie));
  }

  void onWatchWebView() async {
    if (Platform.isAndroid && Platform.isIOS) return;
    _webviewDesktop ??= await WebviewWindow.create(
      configuration: CreateConfiguration(
          title: "${getBook.name} - ${state.currentWatch.data?.name ?? ""}",
          openMaximized: true),
    );
    _webviewDesktop!.launch(state.movie!.data);
    _webviewDesktop?.onClose.then((value) => _webviewDesktop = null);
  }

  void checkNewMovie() {
    readerCubit.refreshChapters();
  }

  @override
  Future<void> close() {
    if (Platform.isMacOS || Platform.isWindows) {
      _webviewDesktop?.close();
    }
    return super.close();
  }
}
