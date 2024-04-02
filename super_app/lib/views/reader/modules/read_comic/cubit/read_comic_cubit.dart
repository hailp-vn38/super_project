import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/views/reader/cubit/reader_cubit.dart';

import '../read_comic.dart';

part 'read_comic_state.dart';

class ReadComicCubit extends Cubit<ReadComicState> {
  ReadComicCubit({required this.readerCubit})
      : super(const ReadComicState(menu: MenuComic.base));

  final ReaderCubit readerCubit;

  Book get getBook => readerCubit.args.book;

  List<Chapter> get getChapters => readerCubit.args.chapters;

  int get getInitialScrollIndex =>
      readerCubit.getCurrentChapter.scrollIndex ?? 0;

  bool _currentOnTouchScreen = false;

  AnimationController? _controller;

  AnimationController? get getAnimationController => _controller;

  ListComicImageController listComicImageController =
      ListComicImageController();

  void onInit() {
    listComicImageController.onChangeIndex = onChangeScrollIndex;
  }

  set setAnimationController(AnimationController controller) {
    _controller = controller;
  }

  Map<String, String> get getHttpHeaders =>
      {"Referer": readerCubit.extension!.source};

  void onTapScreen() {
    if (_isShowMenu || _currentOnTouchScreen) return;
    _onChangeIsShowMenu(true);
    _currentOnTouchScreen = false;
  }

  bool get _isShowMenu => _controller?.status == AnimationStatus.completed;

  // chạm vào màn hình để đọc, ẩn panel nếu đang được hiện thị
  void onTouchScreen() async {
    _currentOnTouchScreen = false;
    if (!_isShowMenu) return;
    _onChangeIsShowMenu(false);
    _currentOnTouchScreen = true;
  }

  Future<void> _onChangeIsShowMenu(bool value) async {
    if (value) {
      await _controller?.forward();
    } else {
      await _controller?.reverse();
    }
  }

  void onChangeScrollIndex(int index) {
    final chapter = readerCubit.getCurrentChapter;
    chapter.scrollIndex = index;
    readerCubit.updateChapter(chapter);
  }

  void onChangeChapter(Chapter chapter) {
    _onChangeIsShowMenu(false);
    readerCubit.getDetailChapter(chapter);
  }

  void perChapter() {
    final index = readerCubit.getCurrentChapter.index!;
    if (index == 0) return;
    listComicImageController.setScrollIndex = 0;

    readerCubit.getDetailChapter(readerCubit.getChapters[index - 1]);
    if (_isShowMenu) {
      _onChangeIsShowMenu(false);
    }
  }

  void nextChapter() {
    final index = readerCubit.getCurrentChapter.index!;
    if (index >= readerCubit.getChapters.length) return;
    listComicImageController.setScrollIndex = 0;
    readerCubit.getDetailChapter(readerCubit.getChapters[index + 1]);
    if (_isShowMenu) {
      _onChangeIsShowMenu(false);
    }
  }

  void startAutoScroll() {
    listComicImageController.enableAutoScroll();
    _onChangeIsShowMenu(false);
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}

enum MenuComic { base, autoScroll }
