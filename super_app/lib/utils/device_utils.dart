import 'dart:io';

import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

class DeviceUtils {
  static Future<void> initWakelock() async {
    final isEnable = await Wakelock.enabled;
    if (isEnable) {
      disableWakelock();
    }
  }

  static Future<void> enableWakelock() {
    return Wakelock.enable();
  }

  static Future<void> disableWakelock() {
    return Wakelock.disable();
  }

  static Future<void> setOrientationAuto() {
    return SystemChrome.setPreferredOrientations([]);
  }

  static Future<void> setOrientationLandscape() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  static Future<void> setOrientationPortrait() {
    return SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static Future<void> setPreferredOrientations() {
    return SystemChrome.setPreferredOrientations([]);
  }

  static Future<void> setRotationDevice() {
    return SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;
}
