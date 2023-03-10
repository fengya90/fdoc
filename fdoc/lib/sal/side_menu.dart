import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fdoc/model/side_menu_model.dart';
import 'package:fdoc/common/common_utils.dart';

Future<SideMenuList> fetchMenu(String fragment) async {
  var dirs = fragment.split("/");
  if (dirs.length < 2) {
    throw Exception('Failed to load content');
  }
  var menuPath = "/${dirs[1]}/menu.json";
  var url = CommonUtils.getUrlByPath(menuPath);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    try {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      var sideMenuList = SideMenuList.fromJson(jsonResponse);
      return sideMenuList;
    } catch (e) {
      return SideMenuList.empty();
    }
  } else {
    return SideMenuList.empty();
  }
}
