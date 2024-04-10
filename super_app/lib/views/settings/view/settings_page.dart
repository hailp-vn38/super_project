part of 'settings_view.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsCubit _settingsCubit;
  @override
  void initState() {
    _settingsCubit = context.read<SettingsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("settings.title".tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              elevation: 0.5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.language_rounded,
                              size: 24,
                            ),
                            Gaps.wGap12,
                            Text(
                              "settings.language".tr(),
                              style: textTheme.bodyMedium,
                            )
                          ],
                        )),
                    PopupMenuButton<Locale>(
                      position: PopupMenuPosition.under,
                      padding: EdgeInsets.zero,
                      initialValue: context.locale,
                      onSelected: (value) {
                        context.setLocale(value);
                      },
                      clipBehavior: Clip.hardEdge,
                      itemBuilder: (context) => context.supportedLocales
                          .map((locale) => PopupMenuItem(
                              value: locale,
                              child:
                                  Text("settings.${locale.languageCode}".tr())))
                          .toList(),
                      child: Row(
                        children: [
                          Gaps.wGap8,
                          Text("settings.${context.locale.languageCode}".tr()),
                          Gaps.wGap8,
                          const Icon(Icons.arrow_drop_down_rounded)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Gaps.hGap8,
            Card(
              margin: EdgeInsets.zero,
              elevation: 0.5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.light_mode,
                              size: 24,
                            ),
                            Gaps.wGap12,
                            Text(
                              "settings.theme".tr(),
                              style: textTheme.bodyMedium,
                            )
                          ],
                        )),
                    BlocSelector<AppCubit, AppState, ThemeMode>(
                      selector: (state) {
                        return state.themeMode;
                      },
                      builder: (context, themeMode) {
                        return PopupMenuButton<ThemeMode>(
                          position: PopupMenuPosition.under,
                          padding: EdgeInsets.zero,
                          initialValue: themeMode,
                          onSelected: (value) {
                            context.read<AppCubit>().onChangeThemeMode(value);
                          },
                          itemBuilder: (context) => ThemeMode.values
                              .map((theme) => PopupMenuItem(
                                  value: theme,
                                  child: Text("settings.${theme.name}".tr())))
                              .toList(),
                          child: Row(
                            children: [
                              Gaps.wGap8,
                              Text("settings.${themeMode.name}".tr()),
                              Gaps.wGap8,
                              const Icon(Icons.arrow_drop_down_rounded)
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  const SettingItem(
      {super.key,
      required this.tilte,
      required this.leading,
      required this.value});
  final String tilte;
  final String value;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    const Icon(
                      Icons.language_rounded,
                      size: 24,
                    ),
                    Gaps.wGap12,
                    Text(
                      "Ngôn ngữ",
                      style: textTheme.bodyMedium,
                    )
                  ],
                )),
            const Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Tiếng việt"),
                    Icon(Icons.arrow_drop_down_rounded)
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
