import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fdoc/sal/get_config.dart';
import 'package:fdoc/common/common_utils.dart';
import 'package:fdoc/model/global_config_model.dart';

final menuIndexProvider = StateProvider<int>((ref) {
  return -1;
});

final fragmentProvider = StateProvider<String>((ref) {
  return "";
});

final initConfigProvider = FutureProvider<GlobalInitConfig>((ref) async {
  var globalInitConfig = await fetchConfig();
  ref.read(fragmentProvider.notifier).update((state) => Uri.base.fragment);
  var path = CommonUtils.getPathFromFragment(Uri.base.fragment);
  int index = -1;
  int pathLen = 0;
  for (var i = 0; i < globalInitConfig.menuList.length; i = i + 1) {
    var mpath = globalInitConfig.menuList[i].path!;
    mpath = CommonUtils.getMenuDirPath(mpath);
    if (pathLen < mpath.length) {
      if (path.startsWith(mpath)) {
        index = i;
        pathLen = mpath.length;
      }
    }
  }
  if (index >= 0) {
    ref.read(menuIndexProvider.notifier).update((state) => index);
  }
  return globalInitConfig;
});
