import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:super_app/app/routes/routes_name.dart';
import 'package:super_app/models/extension.dart';
import 'package:super_app/views/detail/detail.dart';
import 'package:super_app/views/explore/explore.dart';
import 'package:super_app/views/extensions/extensions.dart';
import 'package:super_app/views/genre/genre.dart';
import 'package:super_app/views/home/home.dart';
import 'package:super_app/views/reader/reader.dart';
import 'package:super_app/views/search/search.dart';
import 'package:super_app/views/search_big/search_big.dart';
import 'package:super_app/views/splash/splash.dart';
import 'package:super_app/views/tabs/tabs.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RoutesName.init:
        return PageTransition(
            child: const SplashView(), type: PageTransitionType.rightToLeft);
      case RoutesName.tabs:
        return PageTransition(
            child: const TabsView(), type: PageTransitionType.fade);

      case RoutesName.home:
        return PageTransition(
            child: const HomeView(), type: PageTransitionType.fade);
      case RoutesName.explore:
        return PageTransition(
            child: const ExploreView(), type: PageTransitionType.fade);

      case RoutesName.search:
        assert(args != null && args is SearchArgs, "args must be SearchArgs");

        return PageTransition(
            child: SearchView(
              args: args as SearchArgs,
            ),
            type: PageTransitionType.fade);

      case RoutesName.reader:
        assert(args != null && args is ReaderArgs, "args must be ReaderArgs");

        return PageTransition(
            child: ReaderView(
              args: args as ReaderArgs,
            ),
            type: PageTransitionType.fade);

      case RoutesName.extensions:
        return PageTransition(
            child: const ExtensionsView(),
            type: PageTransitionType.rightToLeft);

      case RoutesName.searchBig:
        return PageTransition(
            child: const SearchBigView(), type: PageTransitionType.fade);

      case RoutesName.detail:
        assert(args != null && args is String, "args must be String");
        return PageTransition(
            child: DetailView(
              bookUrl: args as String,
            ),
            type: PageTransitionType.rightToLeft);

      case RoutesName.genre:
        assert(args != null && args is GenreArgs, "args must be Book");
        return PageTransition(
            // settings: settings,
            child: GenreView(
              arg: args as GenreArgs,
            ),
            type: PageTransitionType.rightToLeft);
      default:
        return _errRoute();
    }
  }

  static Route<dynamic> _errRoute() {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
              appBar: AppBar(title: const Text("No route")),
              body: const Center(
                child: Text("no route"),
              ),
            ));
  }
}
