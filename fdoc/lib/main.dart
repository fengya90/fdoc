import 'package:fdoc/common/common_utils.dart';
import 'package:fdoc/common/global_config.dart';
import 'package:fdoc/state/global_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'router/router.dart';
import 'package:fdoc/model/global_config_model.dart';
import 'package:fdoc/view/header/header_widget.dart';
import 'view/drawer/drawer_widget.dart';

void main() {
  runApp(
    ProviderScope(child: FdocApp()),
  );
}

class FdocApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<GlobalInitConfig> config = ref.watch(initConfigProvider);
    return config.when(
      loading: () {
        return const MaterialApp(
          title: 'loading',
        );
      },
      error: (err, stack) {
        return const MaterialApp(
          title: 'error',
        );
      },
      data: (config) {
        return BeamerProvider(
          routerDelegate: routerDelegate,
          child: MaterialApp.router(
            title: config.title,
            routeInformationParser: BeamerParser(),
            routerDelegate: routerDelegate,
            builder: (context, child) => LayoutBuilder(
              builder: (context, constraints) {
                var isPC = constraints.maxWidth > 600;
                if (!isPC) {
                  return NarrowApp(
                    child: child!,
                    config: config,
                  );
                } else {
                  return WideApp(
                    child: child!,
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class NarrowApp extends HookConsumerWidget {
  NarrowApp({
    Key? key,
    required this.child,
    required this.config,
  }) : super(key: key);

  final Widget child;
  final GlobalInitConfig config;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var scaffold = Scaffold(
      key: _scaffoldKey,
      drawer: DrawerMenuWidget(
        config,
        () => _scaffoldKey.currentState!.openEndDrawer(),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            HeaderWidget(
              openNavigationSidebar: () =>
                  _scaffoldKey.currentState!.openDrawer(),
            ),
            Container(
              height: 1,
              color: commonBackgroundColor,
            ),
            Expanded(child: child)
          ],
        ),
      ),
    );

    return Overlay(
      initialEntries: [
        OverlayEntry(builder: (context) => scaffold),
      ],
    );
  }
}

class WideApp extends StatelessWidget {
  const WideApp({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const HeaderWidget(),
            Container(
              height: 1,
              color: commonBackgroundColor,
            ),
            Expanded(child: child)
          ],
        ),
      ),
    );
    return scaffold;
  }
}
