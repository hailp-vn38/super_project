import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list_extended/scrollable_positioned_list_extended.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/widgets/loading_widget.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../cubit/reader_cubit.dart';
import '../cubit/read_novel_cubit.dart';


part 'read_novel_page.dart';
part '../widgets/base_menu.dart';
part '../widgets/list_content.dart';

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
