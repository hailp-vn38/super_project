import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/read_comic_cubit.dart';

part 'read_comic_page.dart';
part '../widgets/widgets.dart';

class ReadComicView extends StatelessWidget {
  const ReadComicView({super.key});
  static const String routeName = '/read_comic_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReadComicCubit()..onInit(),
      child: const ReadComicPage(),
    );
  }
}
