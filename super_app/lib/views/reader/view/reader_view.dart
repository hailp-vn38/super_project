// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:super_app/app/types.dart';

import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/models/book.dart';
import 'package:super_app/models/chapter.dart';
import 'package:super_app/models/extension.dart';
import 'package:super_app/models/track_read.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/views/reader/modules/read_comic/view/read_comic_view.dart';
import 'package:super_app/views/reader/modules/read_novel/read_novel.dart';
import 'package:super_app/views/reader/modules/watch_movie/watch_movies.dart';

import '../cubit/reader_cubit.dart';

part '../widgets/widgets.dart';
part 'reader_page.dart';

class ReaderView extends StatelessWidget {
  const ReaderView({super.key, required this.args});
  static const String routeName = '/reader_view';
  final ReaderArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReaderCubit(
          databaseService: getIt<DatabaseService>(),
          jsRuntime: getIt<JsRuntime>(),
          args: args)
        ..onInit(),
      child: const ReaderPage(),
    );
  }
}

class ReaderArgs {
  final Extension? extension;
  final Book book;
  final TrackRead track;
  final List<Chapter>? chapters;
  ReaderArgs({
    this.extension,
    required this.book,
    required this.track,
    this.chapters,
  });

  ReaderArgs copyWith({
    Extension? extension,
    Book? book,
    TrackRead? track,
    List<Chapter>? chapters,
  }) {
    return ReaderArgs(
      extension: extension ?? this.extension,
      book: book ?? this.book,
      track: track ?? this.track,
      chapters: chapters ?? this.chapters,
    );
  }
}
