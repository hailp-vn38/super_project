import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tabs_state.dart';

class TabsCubit extends Cubit<TabsState> {
  TabsCubit() : super(const TabsState(currentIndex: 0));

  void onInit() {}

  void onChangeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
