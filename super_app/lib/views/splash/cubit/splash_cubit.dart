import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/di/components/service_locator.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void onInit() {
    test();
  }

  Future test() async {
    getIt.allReady().then((value) {
      emit(AppReady());
    });
  }
}
