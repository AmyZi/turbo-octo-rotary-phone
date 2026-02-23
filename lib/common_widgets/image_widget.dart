import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class ImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? placeholder;
  final double radius;
  const ImageWidget({super.key, required this.image, this.height, this.width, this.fit = BoxFit.cover, this.placeholder = Images.placeholder, this.radius = 0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(placeholder?? Images.placeholder, height: height, width: width, fit: fit?? BoxFit.cover),
        imageUrl: image, fit: fit?? BoxFit.cover,
        height: height,width: width,
        errorWidget: (c, o, s) => Image.asset(placeholder?? Images.placeholder, height: height, width: width, fit: fit?? BoxFit.cover),
      ),
    );
  }
}
