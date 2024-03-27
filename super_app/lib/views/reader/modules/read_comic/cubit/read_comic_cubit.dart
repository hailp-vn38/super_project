import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'read_comic_state.dart';

class ReadComicCubit extends Cubit<ReadComicState> {
  ReadComicCubit() : super(ReadComicInitial());

  void onInit() {}
}
