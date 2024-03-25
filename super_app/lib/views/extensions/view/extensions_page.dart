part of 'extensions_view.dart';

class ExtensionsPage extends StatefulWidget {
  const ExtensionsPage({super.key});

  @override
  State<ExtensionsPage> createState() => _ExtensionsPageState();
}

class _ExtensionsPageState extends State<ExtensionsPage> {
  late ExtensionsCubit _extensionsCubit;
  @override
  void initState() {
    _extensionsCubit = context.read<ExtensionsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Row(
            children: [
              Expanded(
                  child: TabBar(
                      dividerColor: Colors.transparent,
                      // splashBorderRadius: BorderRadius.circular(40),
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.grey,
                      labelPadding: EdgeInsets.zero,
                      labelStyle: textTheme.titleMedium,
                      unselectedLabelStyle: textTheme.titleMedium,
                      // labelColor: textTheme.titleMedium?.color,
                      tabs: const [
                    Tab(
                      text: "Cập nhật",
                    ),
                    Tab(
                      text: "Tất cả nguồn",
                    )
                  ])),
              Gaps.wGap8,
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.search_rounded))
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.only(top: 4),
          child: TabBarView(children: [
            KeepAliveWidget(child: ExtensionsInstall()),
            KeepAliveWidget(child: AllExtensions()),

            // KeepAliveWidget(
            //     child: ExtensionsAllTab(
            //   extensionsCubit: _extensionsCubit,
            // ))
          ]),
        ),
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
    return CustomScrollView(slivers: [
      MultiSliver(children: [
        const SliverPinnedHeader(child: Text("Cập nhật")),
        BlocSelector<ExtensionsCubit, ExtensionsState,
            StateRes<List<Metadata>>>(
          selector: (state) => state.extsUpdate,
          builder: (context, state) {
            return switch (state.status) {
              StatusType.loading => const LoadingWidget(),
              StatusType.loaded => state.data!.isEmpty
                  ? Container(
                      child: Text("K co"),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.horizontalPadding),
                      child: Column(
                          children: state.data!
                              .map((meta) => ExtensionCard(
                                  key: ValueKey(meta.name),
                                  installed: true,
                                  metadataExt: meta,
                                  onTap: () async {
                                    return true;
                                  }))
                              .toList()),
                    ),
              StatusType.error => const Center(
                  child: Text("ERROR"),
                ),
              _ => const SizedBox(),
            };
          },
        ),
        const SliverPinnedHeader(child: Text("Đã cài đặt")),
        BlocSelector<ExtensionsCubit, ExtensionsState,
            StateRes<List<Extension>>>(
          selector: (state) => state.extensions,
          builder: (context, state) {
            return switch (state.status) {
              StatusType.loading => const LoadingWidget(),
              StatusType.loaded => state.data!.isEmpty
                  ? Container(
                      child: Text("k co"),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.horizontalPadding),
                      child: Column(
                          children: state.data!
                              .map((ext) => ExtensionCard(
                                  key: ValueKey(ext.id),
                                  installed: true,
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
      ]),
    ]);
    // return BlocSelector<ExtensionsCubit, ExtensionsState,
    //     StateRes<List<Extension>>>(
    //   selector: (state) => state.extensions,
    //   builder: (context, state) {
    //     return switch (state.status) {
    //       StatusType.loading => const LoadingWidget(),
    //       StatusType.loaded => state.data!.isEmpty
    //           ? const EmptyWidget(
    //               svgType: SvgType.extension,
    //             )
    //           : SingleChildScrollView(
    //               padding: const EdgeInsets.symmetric(
    //                   horizontal: Dimens.horizontalPadding),
    //               child: Column(
    //                   children: state.data!
    //                       .map((ext) => ExtensionCard(
    //                           key: ValueKey(ext.id),
    //                           installed: true,
    //                           metadataExt: ext.metadata,
    //                           onTap: () =>
    //                               _extensionsCubit.onUninstallExt(ext)))
    //                       .toList()),
    //             ),
    //       StatusType.error => const Center(
    //           child: Text("ERROR"),
    //         ),
    //       _ => const SizedBox(),
    //     };
    //   },
    // );
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
              ? const EmptyWidget(
                  svgType: SvgType.extension,
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.horizontalPadding),
                  child: Column(
                      children: state.data!
                          .map((metadata) => ExtensionCard(
                              installed: false,
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

class ExtensionCard extends StatefulWidget {
  const ExtensionCard(
      {super.key,
      required this.metadataExt,
      required this.installed,
      required this.onTap});
  final Metadata metadataExt;
  final bool installed;
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
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.5),
            border: Border.all(color: colorScheme.primaryContainer),
            borderRadius: BorderRadius.circular(Dimens.radius)),
        child: Row(
          children: [
            Gaps.wGap8,
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: ImageWidget(
                image: widget.metadataExt.icon,
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
                      // Gaps.wGap8,
                      // TagExtension(
                      //   text: widget.metadataExt.locale!.split("_").last,
                      //   color: Colors.teal,
                      // ),
                      Gaps.wGap8,
                      TagExtension(
                        text: widget.metadataExt.type!.name.toTitleCase(),
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
    );
  }

  Widget _tradingCardWidget(ColorScheme colorScheme) {
    Widget icon = widget.installed
        ? Icon(
            Icons.delete_forever_rounded,
            color: colorScheme.error,
            size: 24,
          )
        : Icon(
            Icons.download_rounded,
            color: colorScheme.primary,
            size: 24,
          );
    if (_loading) {
      return Container(
        height: 48,
        width: 48,
        padding: const EdgeInsets.only(right: 8),
        child: LoadingWidget(
          radius: 10,
          child: icon,
        ),
      );
    }
    return IconButton(splashRadius: 20, onPressed: _onTap, icon: icon);
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
