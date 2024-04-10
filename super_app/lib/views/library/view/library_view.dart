import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/app/constants/gaps.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/app/mixins/state.dart';
import 'package:super_app/app/routes/routes_name.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/models/book.dart';
import 'package:super_app/models/track_read.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/views/reader/reader.dart';
import 'package:super_app/widgets/widgets.dart';

import '../cubit/library_cubit.dart';

part 'library_page.dart';
part '../widgets/widgets.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});
  static const String routeName = '/library_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryCubit(databaseService: getIt<DatabaseService>())..onInit(),
      child: const LibraryPage(),
    );
  }
}
