import 'package:dio_client/index.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:super_app/app/constants/dimens.dart';
import 'package:super_app/app/constants/gaps.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/app/routes/routes_name.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/views/explore/cubit/explore_cubit.dart';
import 'package:super_app/widgets/widgets.dart';

part 'explore_page.dart';
part '../widgets/explore_empty_ext.dart';
part '../widgets/explore_extension.dart';
part '../widgets/explore_load_ext.dart';
part '../widgets/explore_err.dart';
part '../widgets/extension_genres_tab.dart';
part '../widgets/extensions_bottom_sheet.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});
  static const String routeName = '/explore_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreCubit(
          databaseService: getIt<DatabaseService>(),
          jsRuntime: getIt<JsRuntime>())
        ..onInit(),
      child: const ExplorePage(),
    );
  }
}
