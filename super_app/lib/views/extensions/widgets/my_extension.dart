part of '../view/extensions_view.dart';

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
                                _extensionsCubit.checkExt();
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