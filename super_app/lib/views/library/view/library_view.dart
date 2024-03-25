import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/library_cubit.dart';

part 'library_page.dart';
part '../widgets/widgets.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});
  static const String routeName = '/library_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryCubit()..onInit(),
      child: const LibraryPage(),
    );
  }
}
