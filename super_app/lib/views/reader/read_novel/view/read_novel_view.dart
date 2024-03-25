import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/read_novel_cubit.dart';

part 'read_novel_page.dart';
part '../widgets/widgets.dart';

class ReadNovelView extends StatelessWidget {
  const ReadNovelView({super.key});
  static const String routeName = '/read_novel_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReadNovelCubit()..onInit(),
      child: const ReadNovelPage(),
    );
  }
}
