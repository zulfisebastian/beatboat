import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme/theme_controller.dart';

class CCachedImage extends StatelessWidget {
  final double width;
  final double height;
  final String url;
  final double rounded;

  CCachedImage({
    Key? key,
    required this.width,
    required this.height,
    required this.url,
    this.rounded = 10,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rounded),
          color: _theme.line.value,
        ),
        child: Center(
          child: Icon(Icons.error),
        ),
      ),
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rounded),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          border: Border.all(
            width: 0.1,
            color: _theme.line.value,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rounded),
          color: _theme.card.value,
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      imageUrl: url,
      width: width,
      height: height,
      // memCacheHeight: memHeight,
      // memCacheWidth: memWidth,
      // maxWidthDiskCache: memWidth,
      // maxHeightDiskCache: memHeight,
    );
  }
}
