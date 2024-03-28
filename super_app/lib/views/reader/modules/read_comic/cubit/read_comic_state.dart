// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'read_comic_cubit.dart';

class ReadComicState extends Equatable {
  const ReadComicState({required this.menu});
  final MenuComic menu;
  @override
  List<Object> get props => [menu];

  ReadComicState copyWith({
    MenuComic? menu,
  }) {
    return ReadComicState(
      menu: menu ?? this.menu,
    );
  }
}
