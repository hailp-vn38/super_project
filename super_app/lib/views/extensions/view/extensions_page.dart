part of 'extensions_view.dart';

class ExtensionsPage extends StatefulWidget {
  const ExtensionsPage({super.key});

  @override
  State<ExtensionsPage> createState() => _ExtensionsPageState();
}

class _ExtensionsPageState extends State<ExtensionsPage>
    with SingleTickerProviderStateMixin {
  late ExtensionsCubit _extensionsCubit;

  late TabController _tabController;
  @override
  void initState() {
    _extensionsCubit = context.read<ExtensionsCubit>();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _extensionsCubit.onChangeIndexTab(_tabController.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            Expanded(
                child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey,
              labelPadding: EdgeInsets.zero,
              labelStyle: textTheme.titleMedium,
              unselectedLabelStyle: textTheme.titleMedium,
              splashBorderRadius: const BorderRadius.all(Radius.circular(8)),
              tabs: const [
                Tab(
                  text: "Cập nhật",
                ),
                Tab(
                  text: "Tất cả nguồn",
                )
              ],
            )),
            Gaps.wGap8,
            IconButton(
                onPressed: () {
                  List<Metadata> list = [];
                  if (_tabController.index == 0) {
                    list = (_extensionsCubit.state.extensions.data ?? [])
                        .map((e) => e.metadata)
                        .toList();
                  } else {
                    list = _extensionsCubit.state.allExtension.data ?? [];
                  }
                  showSearch(
                      context: context,
                      delegate: SearchWidget(
                          installed: _tabController.index == 0,
                          list: list,
                          onTapInstall: _extensionsCubit.onInstallExt,
                          onTapUninstall:
                              _extensionsCubit.onUninstallExtByMetadata));
                },
                icon: const Icon(Icons.search_rounded))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: TabBarView(controller: _tabController, children: const [
          KeepAliveWidget(child: ExtensionsInstall()),
          KeepAliveWidget(child: AllExtensions()),
        ]),
      ),
    );
  }
}

class ExtensionsInstall extends StatefulWidget {
  const ExtensionsInstall({super.key});

  @override
  State<ExtensionsInstall> createState() => _ExtensionsInstallState();
}

class _ExtensionsInstallState extends State<ExtensionsInstall> {
  late ExtensionsCubit _extensionsCubit;
  @override
  void initState() {
    _extensionsCubit = context.read<ExtensionsCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _extensionsCubit.getCurrentExtensions();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return CustomScrollView(slivers: [
      MultiSliver(children: [
        BlocSelector<ExtensionsCubit, ExtensionsState,
            StateRes<List<Metadata>>>(
          selector: (state) => state.extsUpdate,
          builder: (context, state) {
            return switch (state.status) {
              StatusType.loading => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Đang tìm kiểm bản cập nhật",
                        style: textTheme.titleMedium,
                      )),
                      LoadingWidget(
                        radius: 8,
                        child: Icon(
                          Icons.extension_rounded,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                      ),
                      Gaps.wGap4
                    ],
                  ),
                ),
              StatusType.loaded => state.data!.isEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Không tìm thấy bản cập nhật",
                            style: textTheme.bodyMedium,
                          )),
                          IconButton(
                              onPressed: () {
                                _extensionsCubit.checkUpdateExtensions();
                              },
                              icon: const Icon(Icons.refresh_rounded))
                        ],
                      ),
                    )
                  : MultiSliver(
                      children: [
                        SliverPinnedHeader(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ColoredBox(
                            color: colorScheme.background,
                            child: Text(
                              "Cập nhật (${state.data?.length ?? 0})",
                              style: textTheme.titleMedium,
                            ),
                          ),
                        )),
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.horizontalPadding),
                          child: Column(
                              children: state.data!
                                  .map((meta) => ExtensionCard(
                                      key: ValueKey(meta.name),
                                      status: StatusExtension.update,
                                      metadataExt: meta,
                                      onTap: () =>
                                          _extensionsCubit.onUpdateExt(meta)))
                                  .toList()),
                        ),
                      ],
                    ),
              StatusType.error => const Center(
                  child: Text("ERROR"),
                ),
              _ => const SizedBox(),
            };
          },
        )
      ]),
      const SliverPadding(padding: EdgeInsets.only(top: 8)),
      MultiSliver(
        children: [
          SliverPinnedHeader(
              child: BlocSelector<ExtensionsCubit, ExtensionsState,
                  StateRes<List<Extension>>>(
            selector: (state) {
              return state.extensions;
            },
            builder: (context, state) {
              int? length = state.data?.length;
              if (state.status == StatusType.loaded) {}
              return Container(
                color: colorScheme.background,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  "Đã cài đặt (${length ?? 0})",
                  style: textTheme.titleMedium,
                ),
              );
            },
          )),
          BlocSelector<ExtensionsCubit, ExtensionsState,
              StateRes<List<Extension>>>(
            selector: (state) => state.extensions,
            builder: (context, state) {
              return switch (state.status) {
                StatusType.loading => const LoadingWidget(),
                StatusType.loaded => state.data!.isEmpty
                    ? SizedBox(
                        height: context.height * 0.5,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.extension_off_rounded,
                              size: 50,
                            ),
                            Gaps.hGap8,
                            Text("Không có dữ liệu")
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.horizontalPadding),
                        child: Column(
                            children: state.data!
                                .map((ext) => ExtensionCard(
                                    key: ValueKey(ext.id),
                                    status: StatusExtension.installed,
                                    metadataExt: ext.metadata,
                                    onTap: () =>
                                        _extensionsCubit.onUninstallExt(ext)))
                                .toList()),
                      ),
                StatusType.error => const Center(
                    child: Text("ERROR"),
                  ),
                _ => const SizedBox(),
              };
            },
          )
        ],
      )
    ]);
  }
}

class AllExtensions extends StatefulWidget {
  const AllExtensions({super.key});

  @override
  State<AllExtensions> createState() => _AllExtensionsState();
}

class _AllExtensionsState extends State<AllExtensions> {
  late ExtensionsCubit _extensionsCubit;
  @override
  void initState() {
    _extensionsCubit = context.read<ExtensionsCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _extensionsCubit.getNetworkExtensions();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExtensionsCubit, ExtensionsState,
        StateRes<List<Metadata>>>(
      selector: (state) => state.allExtension,
      builder: (context, state) {
        return switch (state.status) {
          StatusType.loading => const LoadingWidget(),
          StatusType.loaded => state.data!.isEmpty
              ? SizedBox(
                  height: context.height * 0.5,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.extension_off_rounded,
                        size: 50,
                      ),
                      Gaps.hGap8,
                      Text("Không có dữ liệu")
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.horizontalPadding),
                  child: Column(
                      children: state.data!
                          .map((metadata) => ExtensionCard(
                              status: StatusExtension.install,
                              metadataExt: metadata,
                              onTap: () =>
                                  _extensionsCubit.onInstallExt(metadata)))
                          .toList()),
                ),
          StatusType.error => const Center(
              child: Text("ERROR"),
            ),
          _ => const SizedBox(),
        };
      },
    );
  }
}

enum StatusExtension { install, installed, update }

class ExtensionCard extends StatefulWidget {
  const ExtensionCard(
      {super.key,
      required this.metadataExt,
      required this.status,
      required this.onTap});
  final Metadata metadataExt;
  final StatusExtension status;
  final Future<bool> Function() onTap;

  @override
  State<ExtensionCard> createState() => _ExtensionCardState();
}

class _ExtensionCardState extends State<ExtensionCard> {
  bool _loading = false;

  void _onTap() async {
    setState(() {
      _loading = true;
    });

    await widget.onTap.call();
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.appTextTheme;
    final uri = Uri.parse(widget.metadataExt.source!);

    return GestureDetector(
      onTap: () {
        // showModalBottomSheet(
        //     isScrollControlled: true,
        //     context: context,
        //     builder: (_) => InfoExtensionBottomSheet(
        //           metadata: widget.metadataExt,
        //         ));
      },
      child: Card(
        margin: const EdgeInsets.only(top: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              Gaps.wGap8,
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: ImageWidget(
                  key: ValueKey(widget.metadataExt.name),
                  image: widget.metadataExt.icon,
                  loading: true,
                ),
              ),
              Gaps.wGap8,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.metadataExt.name!,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      uri.host,
                      style: textTheme.bodySmall,
                      maxLines: 2,
                    ),
                    Gaps.hGap4,
                    Row(
                      children: [
                        TagExtension(
                          text: "V${widget.metadataExt.version}",
                          color: Colors.orange,
                        ),
                        Gaps.wGap8,
                        TagExtension(
                          text: widget.metadataExt.type!.name.toTitleCase,
                          color: colorScheme.primary,
                        ),
                        Gaps.wGap8,
                        if (widget.metadataExt.tag != null)
                          TagExtension(
                            text: widget.metadataExt.tag!,
                            color: colorScheme.error,
                          ),
                      ],
                    )
                  ],
                ),
              ),
              _tradingCardWidget(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tradingCardWidget(ColorScheme colorScheme) {
    Map<StatusExtension, Widget> mapIcon = {
      StatusExtension.install: Icon(
        Icons.download_rounded,
        color: colorScheme.primary,
        size: 24,
      ),
      StatusExtension.installed: Icon(
        Icons.delete_forever_rounded,
        color: colorScheme.error,
        size: 24,
      ),
      StatusExtension.update: Icon(
        Icons.download_rounded,
        color: colorScheme.primary,
        size: 24,
      ),
    };
    if (_loading) {
      return Container(
        height: 48,
        width: 48,
        padding: const EdgeInsets.only(right: 8),
        child: LoadingWidget(
          radius: 10,
          child: mapIcon[widget.status],
        ),
      );
    }
    return IconButton(
        splashRadius: 20, onPressed: _onTap, icon: mapIcon[widget.status]!);
  }
}

class TagExtension extends StatelessWidget {
  const TagExtension({super.key, required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: color,
          )),
      child: Text(
        text,
        style: textTheme.labelSmall?.copyWith(fontSize: 8),
      ),
    );
  }
}
