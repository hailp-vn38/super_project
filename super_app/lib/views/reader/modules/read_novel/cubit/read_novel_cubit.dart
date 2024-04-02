import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/views/reader/cubit/reader_cubit.dart';

import '../view/read_novel_view.dart';

part 'read_novel_state.dart';

class ReadNovelCubit extends Cubit<ReadNovelState> {
  ReadNovelCubit({required this.readerCubit})
      : super(const ReadNovelState(menu: MenuType.base));

  final ReaderCubit readerCubit;

  Book get getBook => readerCubit.args.book;

  List<Chapter> get getChapters => readerCubit.args.chapters;

  int get getInitialScrollIndex =>
      readerCubit.getCurrentChapter.scrollIndex ?? 0;

  bool _currentOnTouchScreen = false;
  AnimationController? _controller;

  AnimationController? get getAnimationController => _controller;

  ListContentController controller = ListContentController();

  void onInit() {
    // print(readerCubit.getCurrentChapter.scrollIndex);
    controller.onChangeIndex = onChangeScrollIndex;
  }

  set setAnimationController(AnimationController controller) {
    _controller = controller;
  }

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

  String removeTrashContent(String value) {
    value = value.replaceAll('\n\n', '\n');
    value = value.replaceAll('\n ', '\n\t\t\t\t\t\t\t');

    return value;
  }

  void perChapter() {
    final index = readerCubit.getCurrentChapter.index!;
    if (index == 0) return;
    readerCubit.updateChapter(readerCubit.getCurrentChapter);

    readerCubit.getDetailChapter(readerCubit.getChapters[index - 1]);

    if (_isShowMenu) {
      _onChangeIsShowMenu(false);
    }
  }

  void nextChapter() {
    final index = readerCubit.getCurrentChapter.index!;
    if (index >= readerCubit.getChapters.length) return;
    readerCubit.updateChapter(readerCubit.getCurrentChapter);
    readerCubit.getDetailChapter(readerCubit.getChapters[index + 1]);
    if (_isShowMenu) {
      _onChangeIsShowMenu(false);
    }
  }

  void onChangeScrollIndex(int index) {
    final chapter = readerCubit.getCurrentChapter;
    chapter.scrollIndex = index;
  }

  void onChangeChapter(Chapter chapter) {
    readerCubit.updateChapter(readerCubit.getCurrentChapter);
    readerCubit.getDetailChapter(chapter);
    if (_isShowMenu) {
      _onChangeIsShowMenu(false);
    }
  }

  void hideMenu() {
    if (_isShowMenu) {
      _onChangeIsShowMenu(false);
    }
  }
}
