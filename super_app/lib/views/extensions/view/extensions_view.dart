import 'package:dio_client/index.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:super_app/app/constants/dimens.dart';
import 'package:super_app/app/constants/gaps.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/widgets/widgets.dart';

import '../cubit/extensions_cubit.dart';

part 'extensions_page.dart';
part '../widgets/widgets.dart';

class ExtensionsView extends StatelessWidget {
  const ExtensionsView({super.key});
  static const String routeName = '/extensions_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExtensionsCubit(
          databaseService: getIt<DatabaseService>(),
          dioClient: getIt<DioClient>())
        ..onInit(),
      child: const ExtensionsPage(),
    );
  }
}
