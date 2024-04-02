// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'tabs_cubit.dart';

class TabsState extends Equatable {
  const TabsState({required this.currentIndex});
  final int currentIndex;
  @override
  List<Object> get props => [currentIndex];

  TabsState copyWith({
    int? currentIndex,
  }) {
    return TabsState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
