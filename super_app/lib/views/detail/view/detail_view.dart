import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'package:super_app/app/constants/gaps.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/app/routes/routes_name.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/views/reader/reader.dart';
import 'package:super_app/widgets/widgets.dart';

import '../../genre/genre.dart';
import '../cubit/detail_cubit.dart';

part 'detail_page.dart';
part '../widgets/widgets.dart';
part '../widgets/book_detail.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.bookUrl});
  static const String routeName = '/detail_view';
  final String bookUrl;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailCubit(
          bookUrl: bookUrl,
          jsRuntime: getIt<JsRuntime>(),
          databaseService: getIt<DatabaseService>())
        ..onInit(),
      child: const DetailPage(),
    );
  }
}
