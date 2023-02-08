import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonUtils {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static String getFragmentFromPath(String path) {
    if (path == "") {
      return "/";
    }
    return path;
  }

  static String getPathFromFragment(String fragment) {
    if (fragment == "") {
      return "/";
    }
    return fragment;
  }

  static String getMenuDirPath(String path) {
    if (path == "" || path == "/") {
      return "/";
    }
    if (path.endsWith("/")) {
      return path.substring(0, path.length - 1);
    }
    return path;
  }

  static bool isFirstLevelDir(String path) {
    path = getMenuDirPath(path);
    var arrays = path.split("/");
    if (arrays.length == 2) {
      return true;
    }
    return false;
  }

  static String getContentRealPath(String path) {
    if (path == "" || path == "/") {
      return "/readme.md";
    }
    if (isFirstLevelDir(path)) {
      return "${getMenuDirPath(path)}/readme.md";
    }
    return "$path.md";
  }

  static void setPageTitle(String title, BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: title,
      primaryColor:
          Theme.of(context).primaryColor.value, // This line is required
    ));
  }

  static String getTitleFromMarkdown(String content) {
    content = content.trim();
    var lines = content.split("\n");
    if (lines.isEmpty) {
      return "unknown";
    }
    var line = lines[0];
    while (line.isNotEmpty && line.substring(0, 1) == '#') {
      line = line.substring(1);
    }
    return line.trim();
  }
}
