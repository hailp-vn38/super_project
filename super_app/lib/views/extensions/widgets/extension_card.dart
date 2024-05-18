part of '../view/extensions_view.dart';

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
                        ExtensionTag(
                          text: "V${widget.metadataExt.version}",
                          color: Colors.orange,
                        ),
                        Gaps.wGap8,
                        ExtensionTag(
                          text: widget.metadataExt.type!.name.toTitleCase,
                          color: colorScheme.primary,
                        ),
                        if (widget.metadataExt.locale != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ExtensionTag(
                              text: widget.metadataExt.locale!,
                              color: colorScheme.secondary,
                            ),
                          ),
                        if (widget.metadataExt.isNsfw)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ExtensionTag(
                              text: widget.metadataExt.isNsfw ? "18+" : "",
                              color: Colors.red,
                            ),
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
