import 'package:super_app/views/detail/detail.dart';
import 'package:super_app/views/explore/explore.dart';
import 'package:super_app/views/extensions/extensions.dart';
import 'package:super_app/views/genre/genre.dart';
import 'package:super_app/views/home/home.dart';
import 'package:super_app/views/reader/reader.dart';
import 'package:super_app/views/search/search.dart';
import 'package:super_app/views/tabs/tabs.dart';

class RoutesName {
  RoutesName._();
  static const init = "/";
  static const tabs = TabsView.routeName;
  static const home = HomeView.routeName;
  static const explore = ExploreView.routeName;
  static const detail = DetailView.routeName;
  static const extensions = ExtensionsView.routeName;
  static const search = SearchView.routeName;
  static const reader = ReaderView.routeName;
  static const genre = GenreView.routeName;
}
