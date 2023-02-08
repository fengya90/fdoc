import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fdoc/model/global_config_model.dart';

Future<GlobalInitConfig> fetchConfig() async {
  final response =
      await http.get(Uri.parse('${Uri.base.origin}/config/global.json'));

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    return GlobalInitConfig.newGlobalStateFromMap(jsonResponse);
  } else {
    throw Exception('Failed to load menu');
  }
}
