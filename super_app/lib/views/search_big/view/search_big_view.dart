import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:super_app/app/constants/dimens.dart';
import 'package:super_app/app/constants/gaps.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/app/mixins/state.dart';
import 'package:super_app/app/routes/routes_name.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/models/extension.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/utils/device_utils.dart';
import 'package:super_app/views/extensions/extensions.dart';
import 'package:super_app/views/reader/reader.dart';
import 'package:super_app/views/search/search.dart';
import 'package:super_app/widgets/book_item.dart';
import 'package:super_app/widgets/keep_alive_widget.dart';
import 'package:super_app/widgets/widgets.dart';

import '../cubit/search_big_cubit.dart';

part 'search_big_page.dart';
part '../widgets/widgets.dart';

class SearchBigView extends StatelessWidget {
  const SearchBigView({super.key});
  static const String routeName = '/search_big_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBigCubit(
          databaseService: getIt<DatabaseService>(),
          jsRuntime: getIt<JsRuntime>())
        ..onInit(),
      child: const SearchBigPage(),
    );
  }
}
