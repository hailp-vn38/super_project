import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:media_kit/media_kit.dart';
import 'package:super_app/utils/device_utils.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'app/constants/constants.dart';
import 'di/components/service_locator.dart';

Future<void> _configureMacosWindowUtils() async {
  await DesktopWindow.setMinWindowSize(const Size(800, 600));
  // await windowManager.ensureInitialized();

  // WindowOptions windowOptions = const WindowOptions(
  //   size: Size(800, 600),
  //   minimumSize: Size(800, 600),
  //   center: true,
  //   // backgroundColor: Colors.transparent,
  //   skipTaskbar: false,
  //   titleBarStyle: TitleBarStyle.normal,
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   // await windowManager.show();
  //   // await windowManager.focus();
  //   // await windowManager.setAspectRatio(2 / 3);
  // });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PlatformInAppWebViewController.debugLoggingSettings.enabled = false;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(false);
  }
  await EasyLocalization.ensureInitialized();

  await setupLocator();
  // Bloc.observer = const AppBlocObserver();
  if (Platform.isMacOS || Platform.isWindows) {
    await _configureMacosWindowUtils();
  } else {
    DeviceUtils.setOrientationAuto();
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  MediaKit.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: Constants.supportedLocales,
        path: 'assets/translations',
        fallbackLocale: Constants.defaultLocal,
        child: const App()),
  );
}
