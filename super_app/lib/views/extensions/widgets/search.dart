part of '../view/extensions_view.dart';

class SearchWidget extends SearchDelegate {
  List<Metadata> list;
  SearchWidget(
      {required this.list,
      required this.onTapInstall,
      required this.onTapUninstall,
      required this.installed});
  Future<bool> Function(Metadata) onTapInstall;
  Future<bool> Function(Metadata) onTapUninstall;

  bool installed;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final tmp = super.appBarTheme(context).inputDecorationTheme;

    return context.appTheme.copyWith(inputDecorationTheme: tmp);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _build();

  @override
  Widget buildSuggestions(BuildContext context) => _build();

  List<Metadata> _onSearch() {
    if (query.isEmpty) list;
    return list
        .where((el) => el.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Widget _build() {
    final search = _onSearch();
    if (search.isEmpty) {
      return const Center(
        child: Text("no"),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
      child: Column(
          children: search
              .map((metadata) => ExtensionCard(
                  status: installed
                      ? StatusExtension.installed
                      : StatusExtension.install,
                  metadataExt: metadata,
                  onTap: () async {
                    bool result = false;
                    if (installed) {
                      result = await onTapUninstall(metadata);
                    } else {
                      result = await onTapInstall(metadata);
                    }
                    list = list
                        .where((element) => element.name != metadata.name)
                        .toList();
                    query = query;
                    return result;
                  }))
              .toList()),
    );
  }
}
