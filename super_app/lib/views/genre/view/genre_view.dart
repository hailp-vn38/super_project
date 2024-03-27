import 'package:flutter/material.dart';

import 'package:js_runtime/js_runtime.dart';
import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/widgets/widgets.dart';
import '../../../app/routes/routes_name.dart';
import '../cubit/genre_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'genre_page.dart';

class GenreView extends StatelessWidget {
  const GenreView({super.key, required this.arg});
  static const String routeName = '/genre_view';

  final GenreArgs arg;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenreCubit(
          jsRuntime: getIt<JsRuntime>(),
          extension: arg.extension,
          genre: arg.genre)
        ..onInit(),
      child: const GenrePage(),
    );
  }
}

class GenreArgs {
  final Extension extension;
  final Genre genre;
  GenreArgs({
    required this.extension,
    required this.genre,
  });
}
