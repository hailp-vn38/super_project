import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_app/app/extensions/context_extension.dart';

class PlatformBuildWidget extends StatelessWidget {
  const PlatformBuildWidget({
    super.key,
    required this.mobileBuilder,
    required this.macosBuilder,
  });

  final WidgetBuilder mobileBuilder;
  final WidgetBuilder macosBuilder;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return mobileBuilder(context);
    }
    return macosBuilder(context);
  }
}

class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    super.key,
    required this.mobileWidget,
    required this.macosWidget,
  });

  final Widget mobileWidget;
  final Widget macosWidget;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return mobileWidget;
    }
    return macosWidget;
  }
}

typedef ThemeBuild = Widget Function(BuildContext context, ThemeData themeData,
    TextTheme textTheme, ColorScheme colorScheme);

class ThemeBuildWidget extends StatelessWidget {
  const ThemeBuildWidget({super.key, required this.builder});
  final ThemeBuild builder;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return builder(context, theme, theme.textTheme, theme.colorScheme);
  }
}
