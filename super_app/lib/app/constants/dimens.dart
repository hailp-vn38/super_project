import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_app/app/extensions/context_extension.dart';

class Dimens {
  Dimens._();

  //for all screens
  static const double horizontalPadding = 12.0;
  static const double verticalPadding = 8.0;
  static const horizontalEdgeInsets = EdgeInsets.symmetric(horizontal: 8);

  static final cardBookBorderRadius = BorderRadius.circular(8);

  static const radius = 12.0;

  static int getCrossAxisCount(BuildContext context) {
    final width = context.width;
    return width ~/ getWithBookChild;
  }

  static double get getWithBookChild {
    if (Platform.isAndroid || Platform.isIOS) {
      return 120;
    }
    return 150;
  }

  static double bookAspectRatio = 2 / 3.6;

  static double coverBookAspectRatio = 2 / 2.8;
}
