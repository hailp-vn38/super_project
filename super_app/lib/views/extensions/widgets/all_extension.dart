part of '../view/extensions_view.dart';

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
                                  _extensionsCubit.onInstallByMetadata(metadata)))
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
