part of '../view/explore_view.dart';

class ExploreExtension extends StatefulWidget {
  const ExploreExtension({super.key, required this.exploreCubit});

  final ExploreCubit exploreCubit;

  @override
  State<ExploreExtension> createState() => _ExploreExtensionState();
}

class _ExploreExtensionState extends State<ExploreExtension> {
  late Extension _extension;
  late ExploreCubit _exploreCubit;
  @override
  void initState() {
    _exploreCubit = context.read<ExploreCubit>();
    _extension = (_exploreCubit.state as ExploreLoadedExtension).extension;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              _exploreCubit
                  .getListExtension()
                  .then((extensions) => showModalBottomSheet(
                        elevation: 0,
                        context: context,
                        backgroundColor: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        isScrollControlled: true,
                        builder: (context) => ExtensionsBottomSheet(
                          extensions: extensions,
                          exceptionPrimary: _extension,
                          onSelected: _exploreCubit.onChangeExtension,
                        ),
                      ));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: IconExtension(
                      icon: _extension.metadata.icon,
                    )),
                Gaps.wGap8,
                Flexible(
                    child: Text(
                  _extension.metadata.name ?? "",
                  style: context.appTextTheme.titleMedium,
                )),
                Gaps.wGap8,
                const Icon(
                  Icons.expand_more_rounded,
                  size: 26,
                )
              ],
            ),
          ),
        ),
        actions: [
          if (_extension.script.search != null)
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.search,
                      arguments: _extension);
                },
                icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: BlocBuilder<ExploreCubit, ExploreState>(
        buildWhen: (previous, current) {
          if (previous is ExploreLoadedExtension &&
              current is ExploreLoadedExtension) {
            return previous.status != current.status;
          }
          return false;
        },
        builder: (context, state) {
          if (state is ExploreLoadedExtension) {
            return switch (state.status) {
              StatusType.loading => const LoadingWidget(),
              StatusType.loaded => TabItem(
                  exploreCubit: widget.exploreCubit,
                  extension: state.extension,
                  tabs: state.tabs,
                ),
              StatusType.error => const Text("error"),
              _ => const SizedBox()
            };
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class TabItem extends StatefulWidget {
  const TabItem(
      {super.key,
      required this.extension,
      required this.tabs,
      required this.exploreCubit});
  final Extension extension;
  final List<ItemTabExplore> tabs;
  final ExploreCubit exploreCubit;

  @override
  State<TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ItemTabExplore> _tabs = [];
  List<Tab> _itemTabs = [];
  List<Widget> _tabChildren = [];
  @override
  void initState() {
    _tabs = widget.tabs;
    for (var item in widget.tabs) {
      _itemTabs.add(Tab(
        text: item.title,
      ));
      _tabChildren.add(KeepAliveWidget(
        child: BooksWidget(
          key: ValueKey(item.title),
          url: item.url,
          onFetchListBook: widget.exploreCubit.onGetListBook,
          onTap: (book) {
            Navigator.pushNamed(context, RoutesName.detail,
                arguments: book.url?.replaceUrl(widget.extension.source));
          },
        ),
      ));
    }
    if (widget.extension.script.genre != null) {
      _itemTabs.add(Tab(
        text: "common.genre".tr(),
      ));
      _tabChildren.add(KeepAliveWidget(
          child: ExtensionGenresTab(
        onFetch: widget.exploreCubit.onGetListGenre,
        extension: widget.extension,
      )));
      _tabs.add(ItemTabExplore(title: "common.genre".tr(), url: "url"));
    }

    _tabController = TabController(length: _tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Expanded(
              child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  splashBorderRadius:
                      const BorderRadius.all(Radius.circular(8)),
                  tabs: _itemTabs),
            ),
            ColoredBox(
              color: context.colorScheme.background,
              child: PopupMenuButton<ItemTabExplore>(
                icon: const Icon(Icons.menu_rounded),
                position: PopupMenuPosition.under,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                    maxWidth: context.width * 1 / 2,
                    maxHeight: context.height * 1 / 2),
                onSelected: (value) {
                  _tabController.animateTo(value.index!,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                },
                itemBuilder: (context) => _tabs
                    .asMap()
                    .entries
                    .map(
                      (e) => PopupMenuItem(
                          value: e.value.copyWith(index: e.key),
                          child: Text(e.value.title)),
                    )
                    .toList(),
              ),
            )
          ],
        ),
        Expanded(
            child:
                TabBarView(controller: _tabController, children: _tabChildren))
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
