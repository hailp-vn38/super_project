import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:super_app/app/routes/routes_name.dart';
import 'package:super_app/utils/device_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/app/constants/gaps.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/utils/dialog_utils.dart';
import 'package:super_app/views/reader/cubit/reader_cubit.dart';
import 'package:super_app/app/extensions/string_extension.dart';

import '../cubit/watch_movies_cubit.dart';

part 'watch_movies_page.dart';
part '../widgets/widgets.dart';
part '../widgets/load_err_movie.dart';
part '../widgets/loading_movie.dart';
part '../widgets/play_movie_webview.dart';
part '../widgets/play_media.dart';

part '../widgets/server_name_card.dart';
part '../widgets/chapter_card.dart';

class WatchMoviesView extends StatelessWidget {
  const WatchMoviesView({super.key});
  static const String routeName = '/watch_movies_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WatchMoviesCubit(readerCubit: context.read<ReaderCubit>())..onInit(),
      child: const WatchMoviesPage(),
    );
  }
}
