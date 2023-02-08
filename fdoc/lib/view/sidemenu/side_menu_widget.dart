import 'package:fdoc/common/global_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fdoc/sal/side_menu.dart';
import 'package:fdoc/model/side_menu_model.dart';
import 'package:fdoc/common/common_utils.dart';
import 'package:fdoc/state/global_state.dart';
import 'package:beamer/beamer.dart';
import 'package:fdoc/common/treeview/treeview.dart';

class SideMenuWidget extends HookConsumerWidget {
  const SideMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isPC = CommonUtils.getScreenWidth(context) > 600;
    if (!isPC) {
      return Container();
    }
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
    return Container(
        constraints: BoxConstraints(
            minHeight: CommonUtils.getScreenHeight(context) - kToolbarHeight),
        width: 256,
        child: SingleChildScrollView(
          child: tv,
        ));
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
      },
      child: container,
    );
    return TreeNodeData(data: inkWell, children: null);
  }
}
