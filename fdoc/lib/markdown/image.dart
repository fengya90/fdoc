import 'package:flutter/cupertino.dart';

class MarkdownImage {
  const MarkdownImage();

  static Widget getBaseImage(Image image) {
    Container c1 = Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 0xff, 0xff, 0xff),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 0x88, 0x88, 0x88),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: image,
      ),
    );
    Container c2 = Container(
      alignment: Alignment.center,
      child: c1,
    );
    return c2;
  }
}

Widget FdocImgBuilder(String url, Map<String, String> attributes) {
  if (!(url.startsWith("http://") || url.startsWith("https://"))) {
    if (url.startsWith("/")) {
      url = Uri.base.origin + url;
    } else {
      url = "${Uri.base.origin}/$url";
    }
  }
  return MarkdownImage.getBaseImage(Image.network(url));
}
