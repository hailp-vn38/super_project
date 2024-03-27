part of '../view/explore_view.dart';

typedef OnFetch = Future<List<Genre>> Function();

class ExtensionGenresTab extends StatefulWidget {
  const ExtensionGenresTab(
      {super.key, required this.onFetch, required this.extension});
  final OnFetch onFetch;

  final Extension extension;

  @override
  State<ExtensionGenresTab> createState() => _ExtensionGenresTabState();
}

class _ExtensionGenresTabState extends State<ExtensionGenresTab> {
  bool load = false;
  List<Genre> _listMap = [];
  void _onFetch() async {
    setState(() {
      load = true;
    });
    final tmp = await widget.onFetch.call();
    setState(() {
      _listMap = tmp;
    });

    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    _onFetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (load) {
      return const LoadingWidget();
    }

    return SingleChildScrollView(
      padding: Dimens.horizontalEdgeInsets,
      child: Wrap(
        children: _listMap
            .map((genre) => GenreCard(
                  genre: genre,
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.genre,
                        arguments: GenreArgs(
                            genre: genre, extension: widget.extension));
                  },
                ))
            .toList(),
      ),
    );
  }
}
