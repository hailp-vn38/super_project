part of 'app_cubit.dart';

class AppState extends Equatable {
  const AppState({required this.themeMode});
  final ThemeMode themeMode;

  AppState copyWith({
    ThemeMode? themeMode,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [themeMode];
}
