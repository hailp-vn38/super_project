import 'package:dio_client/index.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/db/db_store.dart';
import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/models/book.dart';
import 'package:super_app/models/chapter.dart';
import 'package:super_app/services/database_service.dart';

import '../cubit/home_cubit.dart';

part 'home_page.dart';
part '../widgets/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = '/home_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..onInit(),
      child: const HomePage(),
    );
  }
}
