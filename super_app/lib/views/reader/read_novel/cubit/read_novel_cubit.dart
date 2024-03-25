import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'read_novel_state.dart';

class ReadNovelCubit extends Cubit<ReadNovelState> {
  ReadNovelCubit() : super(ReadNovelInitial());

  void onInit(){
    
  }
}
