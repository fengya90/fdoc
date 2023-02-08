import 'package:beamer/beamer.dart';
import 'package:fdoc/common/common_utils.dart';
import 'package:fdoc/view/sidemenu/side_menu_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fdoc/sal/get_content.dart';
import 'package:fdoc/state/global_state.dart';
import 'package:markdown_widget/markdown_widget.dart';
import '../../markdown/image.dart';

class ArticleDetailPage extends HookConsumerWidget {
  const ArticleDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isPC = CommonUtils.getScreenWidth(context) > 600;
    List<Widget> rowList = [];
    if (isPC) {
      rowList.add(SideMenuWidget());
      rowList.add(VerticalDivider(
        width: 16,
      ));
    }
    rowList.add(buildContent(context, ref));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowList,
    );
  }

  Widget buildContent(BuildContext context, WidgetRef ref) {
    var fragment = ref.watch(fragmentProvider);
    var path = CommonUtils.getPathFromFragment(fragment);
    final ValueNotifier<String> contentValueNotifier = useState("");
    if (path == "/") {
      return Container();
    }
    useEffect(() {
      Future<void>.microtask(() async {
        try {
          contentValueNotifier.value = await fetchContent(path);
        } catch (e) {
          Beamer.of(context).beamToNamed("/error");
        }
      });
    }, [path]);

    useEffect(() {
      Future<void>.microtask(() async {
        if (path != "/" && path != "/error") {
          CommonUtils.setPageTitle(
              CommonUtils.getTitleFromMarkdown(contentValueNotifier.value),
              context);
        }
      });
    }, [contentValueNotifier.value]);

    final DividerThemeData dividerTheme = DividerTheme.of(context);
    var width = dividerTheme.space ?? 16;

    double maxWidth = CommonUtils.getScreenWidth(context) - width - 256;
    if (CommonUtils.getScreenWidth(context) < 600) {
      maxWidth = CommonUtils.getScreenWidth(context);
    }
    return Container(
      alignment: Alignment.topCenter,
      constraints: BoxConstraints(maxWidth: maxWidth),
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
