import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fdoc/model/global_config_model.dart';
import 'package:fdoc/common/common_utils.dart';

Future<GlobalInitConfig> fetchConfig() async {
  final response =
      await http.get(Uri.parse(CommonUtils.getUrlByPath("/config/global.json")));

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    return GlobalInitConfig.newGlobalStateFromMap(jsonResponse);
  } else {
    throw Exception('Failed to load menu');
  }
}
