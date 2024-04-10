import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/utils/logger.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list_extended/scrollable_positioned_list_extended.dart';
import 'package:super_app/app/constants/gaps.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/app/mixins/state.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/views/reader/cubit/reader_cubit.dart';
import 'package:super_app/views/reader/modules/read_comic/read_comic.dart';
import 'package:super_app/widgets/widgets.dart';

import '../cubit/read_comic_cubit.dart';

part 'read_comic_page.dart';
part '../widgets/base_menu.dart';
part '../widgets/auto_scroll_menu.dart';
part '../widgets/comic_button.dart';
part '../widgets/chapters_drawer.dart';
part '../widgets/list_comic_image.dart';

class ReadComicView extends StatelessWidget {
  const ReadComicView({super.key});
  static const String routeName = '/read_comic_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReadComicCubit(readerCubit: context.read<ReaderCubit>())..onInit(),
      child: const ReadComicPage(),
    );
  }
}
