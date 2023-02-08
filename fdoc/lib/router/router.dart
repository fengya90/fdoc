import 'package:fdoc/view/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:fdoc/view/pages/error_not_found.dart';
import 'package:fdoc/view/pages/article_detail.dart';
import 'package:beamer/beamer.dart';

final routerDelegate = BeamerDelegate(
  setBrowserTabTitle: false,
  transitionDelegate: const NoAnimationTransitionDelegate(),
  locationBuilder: RoutesLocationBuilder(
    routes: {
      RegExp(r'^(?!(/|/error)$).*$'): (_, state, ___) => BeamPage(
            key: ValueKey(state.uri),
            child: const ArticleDetailPage(),
          ),
      '/': (_, __, ___) => const BeamPage(
            key: ValueKey('/'),
            child: HomePage(),
          ),
      '/error': (_, __, ___) => const BeamPage(
            key: ValueKey('/error'),
            child: ErrorNotFoundPage(),
          ),
    },
  ),
);

//
// class NoTransitionPage extends BeamPage {
//   @override
//   final Widget child;
//
//   NoTransitionPage({
//     LocalKey? key,
//     required this.child,
//     bool keepQueryOnPop = false,
//   }) : super(key: key, child: child, keepQueryOnPop: keepQueryOnPop);
//
//   @override
//   Route createRoute(BuildContext context) {
//     return PageRouteBuilder(
//       settings: this,
//       pageBuilder: (context, animation, secondaryAnimation) => child,
//     );
//   }
// }
//
// class FadeTransitionPage extends BeamPage {
//   @override
//   final Widget child;
//   FadeTransitionPage({
//     LocalKey? key,
//     required this.child,
//     bool keepQueryOnPop = false,
//   }) : super(key: key, child: child, keepQueryOnPop: keepQueryOnPop);
//
//   @override
//   Route createRoute(BuildContext context) {
//     return PageRouteBuilder(
//       settings: this,
//       pageBuilder: (_, __, ___) => child,
//       transitionsBuilder: (_, animation, __, child) => FadeTransition(
//         opacity: animation,
//         child: child,
//       ),
//     );
//   }
// }
//
// class ArticleDetailLocation extends BeamLocation<BeamState> {
//   @override
//   List<Pattern> get pathPatterns => [];
//
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) {
//     final pages = [
//       NoTransitionPage(
//         key: ValueKey('detail'),
//         child: ArticleDetailPage(),
//       )
//     ];
//     return pages;
//   }
// }
//
// class HomeLocation extends BeamLocation<BeamState> {
//   @override
//   List<Pattern> get pathPatterns => [];
//
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) {
//     final pages = [
//       NoTransitionPage(
//         key: ValueKey('home'),
//         child: HomePage(),
//       )
//     ];
//     return pages;
//   }
// }
//
// class ErrorNotFoundLocation extends BeamLocation<BeamState> {
//   @override
//   List<Pattern> get pathPatterns => [];
//
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) {
//     final pages = [
//       NoTransitionPage(
//         key: ValueKey('error'),
//         child: ErrorNotFoundPage(),
//       )
//     ];
//     return pages;
//   }
// }

//
//
// final routerDelegate = BeamerDelegate(
//   setBrowserTabTitle:false,
//   transitionDelegate: const NoAnimationTransitionDelegate(),
//   locationBuilder: (routeInformation, _) {
//     var path = routeInformation.location!;
//     if (path == "") {
//       path = "/";
//     }
//     switch (path) {
//       case "/":
//         {
//           return HomeLocation();
//         }
//       case "/error":
//         {
//           return ErrorNotFoundLocation();
//         }
//       default:
//         {
//           return ArticleDetailLocation();
//         }
//     }
//   },
// );
