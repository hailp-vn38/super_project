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
        title: GestureDetector(
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
              StatusType.loaded => _booksWidget(state.extension, state.tabs),
              StatusType.error => const Text("error"),
              _ => const SizedBox()
            };
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _booksWidget(Extension extension, List<ItemTabExplore> tabs) {
    List<Tab> tabItems = tabs
        .map(
          (e) => Tab(
            text: e.title,
          ),
        )
        .toList();
    List<Widget> tabChildren = tabs
        .map(
          (tabHome) => KeepAliveWidget(
            child: BooksWidget(
              key: ValueKey(tabHome.title),
              url: tabHome.url,
              onFetchListBook: widget.exploreCubit.onGetListBook,
              onTap: (book) {
                Navigator.pushNamed(context, RoutesName.detail,
                    arguments: book.url?.replaceUrl(extension.source));
              },
            ),
          ),
        )
        .toList();
    if (extension.script.genre != null) {
      tabItems.add(Tab(
        text: "common.genre".tr(),
      ));
      tabChildren.add(KeepAliveWidget(
          child: ExtensionGenresTab(
        onFetch: _exploreCubit.onGetListGenre,
        extension: extension,
      )));
    }
    return DefaultTabController(
      length: tabItems.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          TabBar(
              isScrollable: true,
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              splashBorderRadius: const BorderRadius.all(Radius.circular(8)),
              tabs: tabItems),
          Expanded(child: TabBarView(children: tabChildren))
        ],
      ),
    );
  }
}
