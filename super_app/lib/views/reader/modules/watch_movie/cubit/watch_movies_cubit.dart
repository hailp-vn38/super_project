import 'dart:async';
import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/views/reader/cubit/reader_cubit.dart';

part 'watch_movies_state.dart';

class WatchMoviesCubit extends Cubit<WatchMoviesState> {
  WatchMoviesCubit({required this.readerCubit})
      : super(const WatchMoviesState());

  final ReaderCubit readerCubit;

  Book get getBook => readerCubit.args.book;

  List<Chapter> get getChapters => readerCubit.getChapters;
  void onInit() async {}

  Webview? _webviewDesktop;

  Player? _playerMedia;
  // Create a [VideoController] to handle video output from [Player].
  VideoController? _controllerMedia;

  VideoController? get getControllerMedia => _controllerMedia;

  Player? get getPlayer => _playerMedia;

  Timer? _updateTimer;

  Map<String, String>? httpHeaders() =>
      {"Access-Control-Allow-Origin": readerCubit.extension!.source};

  void initMediaPlayer() {
    _playerMedia ??= Player();
    _controllerMedia ??= VideoController(_playerMedia!);

    _media();
  }

  void _media() {
    _playerMedia?.stream.position.listen((event) {
      if (_updateTimer == null) {}
    });
  }

  void onSetMovie(Chapter chapter) {
    if (chapter.getMovies == null) return;
    emit(state.copyWith(movie: chapter.getMovies!.first));
  }

  void onChangeChapter(Chapter chapter) {
    readerCubit.onChangeChapter(chapter);
  }

  void onChangeServer(Movie movie) {
    emit(state.copyWith(movie: movie));
  }

  void onWatchWebView() async {
    if (Platform.isAndroid && Platform.isIOS) return;
    _webviewDesktop ??= await WebviewWindow.create(
      configuration: CreateConfiguration(
          title:
              "${getBook.name} - ${readerCubit.state.readCurrentChapter.data?.name ?? ""}",
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

    _playerMedia?.dispose();
    _updateTimer?.cancel();
    return super.close();
  }
}
