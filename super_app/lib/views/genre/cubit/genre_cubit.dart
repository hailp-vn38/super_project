import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/models/models.dart';

part 'genre_state.dart';

class GenreCubit extends Cubit<GenreState> {
  GenreCubit({
    required JsRuntime jsRuntime,
    required Extension extension,
    required Genre genre,
  })  : _jsRuntime = jsRuntime,
        _extension = extension,
        _genre = genre,
        super(GenreInitial());
  final JsRuntime _jsRuntime;
  final Extension _extension;

  final Genre _genre;
  Extension get getExtension => _extension;
  Genre get getGenre => _genre;
  void onInit() {}

  Future<List<Book>> onGetListBook(int page) async {
    try {
      final result = await _jsRuntime.getList<List<dynamic>>(
          url: _genre.url!.replaceUrl(_extension.source),
          page: page,
          jsScript: _extension.getHomeScript);
      return result.map<Book>((e) => Book.fromMap(e)).toList();
    } catch (error) {
      //
    }
    return [];
  }

  String get titleGenre => _genre.title!;
}
