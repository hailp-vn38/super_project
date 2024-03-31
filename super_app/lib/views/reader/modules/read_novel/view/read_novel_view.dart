import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/widgets/loading_widget.dart';

import '../../../cubit/reader_cubit.dart';
import '../cubit/read_novel_cubit.dart';
import 'package:super_app/app/constants/gaps.dart';

import '../../read_comic/view/read_comic_view.dart';

part 'read_novel_page.dart';
part '../widgets/base_menu.dart';

class ReadNovelView extends StatelessWidget {
  const ReadNovelView({super.key});
  static const String routeName = '/read_novel_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReadNovelCubit(readerCubit: context.read<ReaderCubit>())..onInit(),
      child: const ReadNovelPage(),
    );
  }
}
