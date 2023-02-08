class SideMenuLink {
  String title;
  String path;

  SideMenuLink(this.title, this.path);

  SideMenuLink.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        path = json['path'];
}

class SideMenuItem {
  String title;
  List<SideMenuLink> linkList;

  SideMenuItem(this.title, this.linkList);

  static SideMenuItem fromJson(Map<String, dynamic> json) {
    var title = json['title'];
    List<dynamic> linkList = json['link_list'];
    List<SideMenuLink> sideMenuLinkList = List.generate(
        linkList.length, (index) => SideMenuLink.fromJson(linkList[index]));
    return SideMenuItem(title, sideMenuLinkList);
  }
}

class SideMenuList {
  List<SideMenuItem> sideMenuItemList;

  SideMenuList(this.sideMenuItemList);

  static SideMenuList fromJson(List<dynamic> json) {
    List<SideMenuItem> sideMenuItemList = List.generate(
        json.length, (index) => SideMenuItem.fromJson(json[index]));
    return SideMenuList(sideMenuItemList);
  }

  static SideMenuList empty() {
    return SideMenuList(List.empty());
  }
}
