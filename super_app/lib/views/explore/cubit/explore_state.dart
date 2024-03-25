part of 'explore_cubit.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();
  @override
  List<Object> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoadExtension extends ExploreState {}

class ExploreLoadedExtension extends ExploreState {
  final Extension extension;
  final List<ItemTabExplore> tabs;
  final StatusType status;
  const ExploreLoadedExtension(
      {required this.extension, required this.status, required this.tabs});
  @override
  List<Object> get props => [extension, tabs, status];

  ExploreLoadedExtension copyWith(
      {Extension? extension, List<ItemTabExplore>? tabs, StatusType? status}) {
    return ExploreLoadedExtension(
        extension: extension ?? this.extension,
        tabs: tabs ?? this.tabs,
        status: status ?? this.status);
  }
}

class ExploreEmptyExtension extends ExploreState {}

class ExploreError extends ExploreState {
  final String error;
  const ExploreError(this.error);
}

class ItemTabExplore {
  final String title;
  final String url;
  ItemTabExplore({
    required this.title,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
    };
  }

  factory ItemTabExplore.fromMap(Map<String, dynamic> map) {
    return ItemTabExplore(
      title: map['title'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemTabExplore.fromJson(String source) =>
      ItemTabExplore.fromMap(json.decode(source) as Map<String, dynamic>);
}
