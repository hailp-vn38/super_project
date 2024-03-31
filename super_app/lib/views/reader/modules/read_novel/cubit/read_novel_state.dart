// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'read_novel_cubit.dart';

enum MenuType { base, media }

class ReadNovelState extends Equatable {
  const ReadNovelState({required this.menu});
  final MenuType menu;
  @override
  List<Object> get props => [menu];

  ReadNovelState copyWith({
    MenuType? menu,
  }) {
    return ReadNovelState(
      menu: menu ?? this.menu,
    );
  }
}
