import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/di/components/service_locator.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState(status: StatusType.init));

  void onInit() async {
    getIt
        .allReady()
        .then((value) => emit(const SplashState(status: StatusType.loaded)))
        .catchError((err) => emit(const SplashState(status: StatusType.error)));
  }
}
