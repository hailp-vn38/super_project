import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/app/blocs/cubit/app_cubit.dart';
import 'package:super_app/app/routes/routes_name.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/services/settings_service.dart';
import 'package:super_app/views/home/home.dart';
import 'app/routes/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit(
              settingService: getIt<SettingService>(),
              databaseService: getIt<DatabaseService>())
            ..onInit(),
        )
      ],
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (previous, current) {
          if (previous.themeMode != current.themeMode) return true;
          return false;
        },
        builder: (context, state) {
          return MaterialApp(
            title: 'Super app',
            theme: FlexThemeData.light(
              scheme: FlexScheme.deepPurple,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 7,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 10,
                blendOnColors: false,
                useTextTheme: true,
                useM2StyleDividerInM3: true,
                alignedDropdown: true,
                useInputDecoratorThemeInDialogs: true,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              swapLegacyOnMaterial3: true,
              // To use the Playground font, add GoogleFonts package and uncomment
              // fontFamily: GoogleFonts.notoSans().fontFamily,
              fontFamily: "Lora",
            ),
            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.deepPurple,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 13,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 20,
                useTextTheme: true,
                useM2StyleDividerInM3: true,
                alignedDropdown: true,
                useInputDecoratorThemeInDialogs: true,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              swapLegacyOnMaterial3: true,
              // To use the Playground font, add GoogleFonts package and uncomment
              fontFamily: "Lora",
            ),
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            onGenerateRoute: Routes.onGenerateRoute,
            initialRoute: RoutesName.init,
            // home: HomeView(),
          );
        },
      ),
    );
  }
}
