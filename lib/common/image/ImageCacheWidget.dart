import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:super_home_work_2/constant/RquestUrl.dart';

class ImageCacheWidget {
  static get({
    required path,
    String? testUrl,
    double? width,
    double? height,
    double? radius,
    BoxFit? fit,
  }) {
    String url = "";

    if (testUrl == null) {
      url = RequestUrl.baseUrl + RequestUrl.systemImage + path;
    } else {
      url = testUrl;
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
      child: CachedNetworkImage(
        width: width,
        fit: fit == null ? BoxFit.cover : fit,
        height: height,
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: url,
        cacheKey: url,
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
