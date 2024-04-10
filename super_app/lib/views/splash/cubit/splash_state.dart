part of 'splash_cubit.dart';

class SplashState extends Equatable {
  const SplashState({required this.status});
  final StatusType status;
  @override
  List<Object> get props => [status];
}
