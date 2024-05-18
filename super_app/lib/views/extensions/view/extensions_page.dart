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
            // Gaps.wGap8,
          ],
        ),
        actions: [
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
                        onTapInstall: _extensionsCubit.onInstallByMetadata,
                        onTapUninstall:
                            _extensionsCubit.onUninstallExtByMetadata));
              },
              icon: const Icon(Icons.search_rounded)),
          PopupMenuButton(
              position: PopupMenuPosition.under,
              icon: const Icon(Icons.more_vert_rounded),
              offset: const Offset(0, 12),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text("Nhập url"),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) => const ImportUrl(),
                        ).then((value) {
                          if (value == null) return;
                          _extensionsCubit.onInstallByUrl(value);
                        });
                      },
                    ),
                    PopupMenuItem(
                      onTap: _extensionsCubit.pickFileZip,
                      child: const Text("Nhập file zip"),
                    ),
                  ])
        ],
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

class ImportUrl extends StatefulWidget {
  const ImportUrl({super.key});

  @override
  State<ImportUrl> createState() => _ImportUrlState();
}

class _ImportUrlState extends State<ImportUrl> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gaps.hGap16,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Nhập url json",
                  hintStyle: context.appTextTheme.bodyMedium,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
              onSubmitted: (text) {
                Navigator.pop(context, text != "" ? text : null);
              },
            ),
          ),
          Gaps.hGap16,
        ],
      ),
    );
  }
}
