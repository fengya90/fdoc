import 'package:flutter/material.dart';
import 'package:fdoc/state/global_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'header_menu.dart';
import 'package:fdoc/model/global_config_model.dart';
import 'package:fdoc/common/global_config.dart';

class HeaderWidget extends HookConsumerWidget {
  const HeaderWidget({
    Key? key,
    this.openNavigationSidebar,
  }) : super(key: key);

  final void Function()? openNavigationSidebar;

  Row buildMenuList(GlobalInitConfig config) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
          config.menuList.length,
          (index) => HeaderMenuWidget(
                config.menuList[index].title!,
                config.menuList[index].path!,
                index,
              )),
    );
  }

  Row buildPCRow(GlobalInitConfig config) {
    var title = Text(
      config.title,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 22,
        // color: Colors.white,
      ),
    );
    var menulist = buildMenuList(config);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(flex: 1, child: Center(child: title)),
        Expanded(
          flex: 1,
          child: menulist,
        ),
      ],
    );
  }

  Row buildMobileRow(GlobalInitConfig config, int menuIndex) {
    String title = config.title;
    if (menuIndex >= 0 && menuIndex < config.menuList.length) {
      title = config.menuList[menuIndex].title!;
    }

    var menuIcon = Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: openNavigationSidebar,
        child: const Icon(Icons.menu),
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        menuIcon,
        Expanded(
            flex: 1,
            child: Center(
                child: Text(title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                      // color: Colors.white,
                    )))),
      ],
    );
  }

  Row buildRow(WidgetRef ref) {
    AsyncValue<GlobalInitConfig> config = ref.watch(initConfigProvider);
    final menuIndex = ref.watch(menuIndexProvider);
    return config.when(
      loading: () => Row(),
      error: (err, stack) => Row(),
      data: (config) {
        if (openNavigationSidebar == null) {
          return buildPCRow(config);
        } else {
          return buildMobileRow(config, menuIndex);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var color = mainColor;
    if (openNavigationSidebar == null) {
      color = barColor;
    }
    return Container(
      height: kToolbarHeight,
      width: double.infinity,
      color: color,
      child: buildRow(ref),
    );
  }
}
