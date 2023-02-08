import 'package:fdoc/common/global_config.dart';
import 'package:fdoc/state/global_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:fdoc/model/global_config_model.dart';
import 'package:fdoc/common/common_utils.dart';
import 'package:fdoc/common/treeview/treeview.dart';
import 'package:fdoc/model/side_menu_model.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fdoc/sal/side_menu.dart';

class DrawerMenuWidget extends HookConsumerWidget {
  final GlobalInitConfig config;
  final void Function() closeDrawer;

  const DrawerMenuWidget(this.config, this.closeDrawer, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuIndex = ref.watch(menuIndexProvider);
    final ValueNotifier<SideMenuList> menuNotifier =
        useState(SideMenuList.empty());

    var fragment = ref.watch(fragmentProvider);
    useEffect(() {
      Future<void>.microtask(() async {
        if (CommonUtils.getPathFromFragment(fragment) != "/") {
          menuNotifier.value = await fetchMenu(fragment);
        }
      });
    }, [fragment]);

    List<TreeNodeData> menuNodes = List.generate(
      menuNotifier.value.sideMenuItemList.length,
      (index) => buildSideMenuItemNode(
          menuNotifier.value.sideMenuItemList[index], context, ref),
    );

    var tv = TreeView(data: menuNodes);
    List<Widget> sideList = [];
    for (int index = 0; index < config.menuList.length; index++) {
      var listTitle = ListTile(
          title: Text(config.menuList[index].title!,
              style: TextStyle(
                color: menuIndex == index ? mainColor : Colors.black,
              )),
          onTap: () {
            ref.read(menuIndexProvider.notifier).update((state) => index);
            ref.read(fragmentProvider.notifier).update((state) =>
                CommonUtils.getFragmentFromPath(config.menuList[index].path!));
            Beamer.of(context).beamToNamed(
                CommonUtils.getFragmentFromPath(config.menuList[index].path!));
            if (config.menuList[index].path == "/" ||
                !CommonUtils.isFirstLevelDir(config.menuList[index].path!)) {
              closeDrawer.call();
            }
          });
      sideList.add(listTitle);
      if (menuIndex == index) {
        if (config.menuList[index].path != "/") {
          sideList.add(tv);
        }
      }
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: mainColor,
            ),
            child: Text(config.title),
          ),
          ...sideList,
        ],
      ),
    );
  }

  TreeNodeData buildSideMenuItemNode(
      SideMenuItem sideMenuItem, BuildContext context, WidgetRef ref) {
    var linkList = List.generate(
      sideMenuItem.linkList.length,
      (index) =>
          buildSideMenuLinkNode(sideMenuItem.linkList[index], context, ref),
    );

    var sideMenuItemTitle = Container(
      child: Text(
        sideMenuItem.title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    return TreeNodeData(data: sideMenuItemTitle, children: linkList);
  }

  TreeNodeData buildSideMenuLinkNode(
      SideMenuLink sideMenuLink, BuildContext context, WidgetRef ref) {
    final fragment = ref.watch(fragmentProvider);
    var container = Container(
      child: Text(
        sideMenuLink.title,
        style: TextStyle(
            color:
                CommonUtils.getPathFromFragment(fragment) == sideMenuLink.path
                    ? mainColor
                    : Colors.black,
            fontWeight:
                CommonUtils.getPathFromFragment(fragment) == sideMenuLink.path
                    ? FontWeight.w700
                    : FontWeight.w400),
      ),
    );
    var inkWell = InkWell(
      onTap: () {
        var fragment = CommonUtils.getFragmentFromPath(sideMenuLink.path);
        ref.read(fragmentProvider.notifier).update((state) => fragment);
        Beamer.of(context).beamToNamed(fragment);
        closeDrawer.call();
      },
      child: container,
    );
    return TreeNodeData(data: inkWell, children: null);
  }
}
