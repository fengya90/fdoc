import 'package:fdoc/common/global_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fdoc/state/global_state.dart';
import 'package:beamer/beamer.dart';
import 'package:fdoc/common/common_utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ErrorNotFoundPage extends HookConsumerWidget {
  const ErrorNotFoundPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var fragment = ref.watch(fragmentProvider);
    var path = CommonUtils.getPathFromFragment(fragment);
    useEffect(() {
      Future<void>.microtask(() async {
        if (path == "/error") {
          CommonUtils.setPageTitle("error", context);
        }
      });
    }, [path]);

    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
        ),
        onPressed: () {
          ref.read(fragmentProvider.notifier).update((state) => "");
          ref.read(menuIndexProvider.notifier).update((state) => -1);
          Beamer.of(context).beamToNamed("/");
        },
        child: const Text("Go to home page"),
      ),
    );
  }
}
