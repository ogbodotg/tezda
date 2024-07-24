import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tezda/theme/colour.dart';

class UserServices {
  Widget cachedImage({imageUrl, height, width}) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: SizedBox(
        height: 1.0,
        width: 35.0,
        child: LinearProgressIndicator(
          value: downloadProgress.progress,
          color: AppColour.primary.withOpacity(0.4),
        ),
      )),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
