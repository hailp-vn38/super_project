import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logging/logging.dart';

import 'app.dart';
import 'app/constants/constants.dart';
import 'di/components/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PlatformInAppWebViewController.debugLoggingSettings.enabled = false;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(false);
  }
  // await InAppWebViewController.setWebContentsDebuggingEnabled(false);
  await EasyLocalization.ensureInitialized();

  await setupLocator();
  // Bloc.observer = const AppBlocObserver();
  Logger.root.level = Level.ALL;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(
    EasyLocalization(
        supportedLocales: Constants.supportedLocales,
        path: 'assets/translations',
        fallbackLocale: Constants.defaultLocal,
        child: const App()),
  );
}
