// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';

import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/app/routes/routes_name.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/models/extension.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/widgets/widgets.dart';

import '../cubit/search_cubit.dart';

part '../widgets/widgets.dart';
part 'search_page.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key, required this.args});
  static const String routeName = '/search_view';
  final SearchArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(
          jsRuntime: getIt<JsRuntime>(),
          extension: args.extension,
          searchWord: args.searchWord)
        ..onInit(),
      child: const SearchPage(),
    );
  }
}

class SearchArgs {
  final Extension extension;
  final String? searchWord;
  SearchArgs({
    required this.extension,
    this.searchWord,
  });
}
