import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/views/reader/cubit/reader_cubit.dart';

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

  ValueNotifier<double> scrollChapter = ValueNotifier<double>(0.0);

  void onInit() {
    // print(readerCubit.getCurrentChapter.scrollIndex);
  }

  set setAnimationController(AnimationController controller) {
    _controller = controller;
    scrollChapter.value = 0;
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
    return value;
  }
}
