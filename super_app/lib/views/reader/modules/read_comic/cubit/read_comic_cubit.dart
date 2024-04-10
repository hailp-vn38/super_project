import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/utils/logger.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/views/reader/cubit/reader_cubit.dart';

import '../read_comic.dart';

part 'read_comic_state.dart';

class ReadComicCubit extends Cubit<ReadComicState> {
  ReadComicCubit({required this.readerCubit})
      : super(const ReadComicState(menu: MenuComic.base));

  final _logger = Logger("ReadComicCubit");

  final ReaderCubit readerCubit;

  Book get getBook => readerCubit.args.book;

  List<Chapter> get getChapters => readerCubit.args.chapters;

  bool _currentOnTouchScreen = false;

  AnimationController? _controller;

  AnimationController? get getAnimationController => _controller;

  ListScrollController listScrollController =
      ListScrollController(defaultDurationAutoScroll: 40);

  void onInit() {
    listScrollController.onScrollMax = () async {
      final isNext = nextChapter();
      if (!isNext) {
        _logger.info("close autoScroll");
        closeAutoScroll();
      }
    };
    listScrollController.scrollPosition.addListener(() {
      final scrollPosition = listScrollController.scrollPosition.value;

      readerCubit.updateScrollReader(
          offset: scrollPosition.offset,
          percent:
              ((scrollPosition.offset / scrollPosition.maxScrollExtent) * 100)
                  .toInt());
    });
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

  void onChangeChapter(Chapter chapter) {
    _onChangeIsShowMenu(false);
    readerCubit.getDetailChapter(chapter);
  }

  void perChapter() {
    final index = readerCubit.getCurrentChapter.index!;
    if (index == 0) return;
    // listComicImageController.setScrollIndex = 0;

    readerCubit.getDetailChapter(readerCubit.getChapters[index - 1]);
    if (_isShowMenu) {
      _onChangeIsShowMenu(false);
    }
  }

  bool nextChapter() {
    final index = readerCubit.getCurrentChapter.index!;
    if (index + 1 >= readerCubit.getChapters.length) return false;
    readerCubit.getDetailChapter(readerCubit.getChapters[index + 1]);
    if (_isShowMenu) {
      _onChangeIsShowMenu(false);
    }
    return true;
  }

  void enableAutoScroll() async {
    await _onChangeIsShowMenu(false);
    emit(state.copyWith(menu: MenuComic.autoScroll));
    listScrollController.enableAutoScroll();
  }

  void closeAutoScroll() async {
    await _onChangeIsShowMenu(false);
    emit(state.copyWith(menu: MenuComic.base));
    listScrollController.stopAutoScroll();
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    listScrollController.dispose();
    return super.close();
  }
}

enum MenuComic { base, autoScroll }
