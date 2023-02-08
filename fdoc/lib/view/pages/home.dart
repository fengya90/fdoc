import 'package:fdoc/common/common_utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fdoc/state/global_state.dart';
import 'package:fdoc/model/global_config_model.dart';
import 'package:markdown_widget/markdown_widget.dart';
import '../../markdown/image.dart';
import 'package:fdoc/sal/get_content.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildContent(context, ref),
      ],
    );
  }

  Widget buildContent(BuildContext context, WidgetRef ref) {
    AsyncValue<GlobalInitConfig> config = ref.watch(initConfigProvider);
    final ValueNotifier<String> titleNotifier = useState("");
    final ValueNotifier<String> contentValueNotifier = useState("");
    final ValueNotifier<String> titleValueNotifier = useState("Home");

    config.when(
      loading: () {},
      error: (err, stack) {},
      data: (config) {
        titleNotifier.value = config.title;
        var homeTitle = "";
        for (int i = 0; i < config.menuList.length; i = i + 1) {
          if (config.menuList[i].path == "/") {
            homeTitle = config.menuList[i].title!;
          }
          if (homeTitle == "") {
            homeTitle = config.title;
          }
          titleValueNotifier.value = homeTitle;
        }
      },
    );
    var fragment = ref.watch(fragmentProvider);
    var path = CommonUtils.getPathFromFragment(fragment);
    useEffect(() {
      Future<void>.microtask(() async {
        if (path == "/") {
          try {
            contentValueNotifier.value = await fetchContent(path);
            CommonUtils.setPageTitle(titleValueNotifier.value, context);
          } catch (e) {
            contentValueNotifier.value = "loading faild";
          }
        }
      });
    }, [path, titleValueNotifier.value]);

    useEffect(() {
      Future<void>.microtask(() async {
        if (path != "/" && path != "/error") {
          CommonUtils.setPageTitle(
              CommonUtils.getTitleFromMarkdown(contentValueNotifier.value),
              context);
        }
      });
    }, [contentValueNotifier.value]);
    return Container(
      alignment: Alignment.topCenter,
      constraints:
          BoxConstraints(maxWidth: CommonUtils.getScreenWidth(context)/3*2),
      child: MarkdownWidget(
          padding: EdgeInsets.all(50),
          data: contentValueNotifier.value,
          shrinkWrap: true,
          config: MarkdownConfig(configs: [
            ImgConfig(
              builder: FdocImgBuilder,
            ),
          ])),
    );
  }
}
