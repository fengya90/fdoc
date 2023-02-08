import 'package:fdoc/common/global_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fdoc/state/global_state.dart';
import 'package:fdoc/common/common_utils.dart';
import 'package:beamer/beamer.dart';

class HeaderMenuWidget extends HookConsumerWidget {
  final String title;
  final String path;
  final int index;

  const HeaderMenuWidget(this.title, this.path, this.index, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuIndex = ref.watch(menuIndexProvider);
    return InkWell(
      onTap: () {
        ref.read(menuIndexProvider.notifier).update((state) => index);
        ref
            .read(fragmentProvider.notifier)
            .update((state) => CommonUtils.getFragmentFromPath(path));
        Beamer.of(context).beamToNamed(CommonUtils.getFragmentFromPath(path));
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Text(
          title,
          style: TextStyle(
              fontWeight:
                  menuIndex == index ? FontWeight.w700 : FontWeight.w400,
              color: menuIndex == index ? mainColor : Colors.black,
              fontSize: 16),
        ),
      ),
    );
  }
}
