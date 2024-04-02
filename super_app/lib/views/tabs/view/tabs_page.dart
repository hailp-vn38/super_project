part of 'tabs_view.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  late TabsCubit _tabsCubit;
  @override
  void initState() {
    _tabsCubit = context.read<TabsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    const tabs = [LibraryView(), ExploreView(), SettingsView()];
    return BlocSelector<TabsCubit, TabsState, int>(
      selector: (state) => state.currentIndex,
      builder: (context, currentIndex) {
        return PlatformWidget(
            mobileWidget: Scaffold(
              body: IndexedStack(index: currentIndex, children: tabs),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: colorScheme.surface))),
                child: NavigationBar(
                  elevation: 0,
                  onDestinationSelected: _tabsCubit.onChangeIndex,
                  selectedIndex: currentIndex,
                  backgroundColor: context.colorScheme.background,
                  destinations: <NavigationDestination>[
                    NavigationDestination(
                      selectedIcon: const Icon(Icons.library_books_rounded),
                      icon: const Icon(Icons.library_books_outlined),
                      label: 'library.title'.tr(),
                    ),
                    NavigationDestination(
                      selectedIcon: const Icon(Icons.widgets_rounded),
                      icon: const Icon(Icons.widgets_outlined),
                      label: "explore.title".tr(),
                    ),
                    NavigationDestination(
                      selectedIcon: const Icon(Icons.settings_rounded),
                      icon: const Icon(Icons.settings_outlined),
                      label: "settings.title".tr(),
                    ),
                  ],
                ),
              ),
            ),
            macosWidget: Scaffold(
              body: Row(children: [
                NavigationRail(
                  onDestinationSelected: _tabsCubit.onChangeIndex,
                  selectedIndex: currentIndex,
                  backgroundColor: context.colorScheme.background,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      selectedIcon: const Icon(Icons.library_books_rounded),
                      icon: const Icon(Icons.library_books_outlined),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      label: Text('library.title'.tr()),
                    ),
                    NavigationRailDestination(
                      selectedIcon: const Icon(Icons.widgets_rounded),
                      icon: const Icon(Icons.widgets_outlined),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      label: Text("explore.title".tr()),
                    ),
                    NavigationRailDestination(
                      selectedIcon: const Icon(Icons.settings_rounded),
                      icon: const Icon(Icons.settings_outlined),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      label: Text("settings.title".tr()),
                    ),
                  ],
                ),
                Expanded(
                    child: IndexedStack(index: currentIndex, children: tabs))
              ]),
            ));
      },
    );
  }
}
