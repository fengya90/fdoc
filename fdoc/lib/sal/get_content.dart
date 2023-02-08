import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fdoc/common/common_utils.dart';

Future<String> fetchContent(String path) async {
  var url = Uri.base.origin + CommonUtils.getContentRealPath(path);
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var message = utf8.decode(response.bodyBytes);
    return message;
  } else {
    throw Exception('Failed to load content');
  }
}
