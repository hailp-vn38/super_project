import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/app/constants/gaps.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/utils/device_utils.dart';
import 'package:super_app/views/explore/view/explore_view.dart';
import 'package:super_app/views/library/library.dart';
import 'package:super_app/views/settings/settings.dart';
import 'package:super_app/widgets/widgets.dart';

import '../cubit/tabs_cubit.dart';

part 'tabs_page.dart';
part '../widgets/widgets.dart';



class TabsView extends StatelessWidget {
  const TabsView({super.key});
  static const String routeName = '/tabs_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabsCubit()..onInit(),
      child: const TabsPage(),
    );
  }
}
