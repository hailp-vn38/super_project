import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/app/routes/routes_name.dart';

import '../cubit/splash_cubit.dart';

part 'splash_page.dart';
part '../widgets/widgets.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String routeName = '/splash_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..onInit(),
      child: const SplashPage(),
    );
  }
}
