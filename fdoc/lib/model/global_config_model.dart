class MenuItem {
  String? title;
  String? path;

  MenuItem(this.title, this.path);
}

class GlobalInitConfig {
  String title = "fdoc";
  List<MenuItem> menuList = [];

  static GlobalInitConfig newGlobalStateFromMap(Map<String, dynamic> m) {
    GlobalInitConfig gic = GlobalInitConfig();
    String title = m["title"];
    gic.title = title;
    var menuList = m["menu_list"];
    gic.menuList = List.generate(menuList.length, (index) {
      var path = menuList[index]["path"];
      if (path == "") {
        path = "/";
      }
      return MenuItem(menuList[index]["title"], path);
    });
    return gic;
  }
}
