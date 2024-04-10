import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:super_app/app/blocs/cubit/app_cubit.dart';
import 'package:super_app/app/constants/gaps.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../cubit/settings_cubit.dart';

part 'settings_page.dart';
part '../widgets/widgets.dart';



class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  static const String routeName = '/settings_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit()..onInit(),
      child: const SettingsPage(),
    );
  }
}
