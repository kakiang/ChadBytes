import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArticleThumbnail extends StatefulWidget {
  const ArticleThumbnail(this.url,
      {Key? key, required this.width, required this.height, this.radius = true})
      : super(key: key);

  final String url;
  final double width;
  final double height;
  final bool radius;

  @override
  _ArticleThumbnailState createState() => _ArticleThumbnailState();
}

class _ArticleThumbnailState extends State<ArticleThumbnail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CachedNetworkImage(
          imageUrl: widget.url,
          imageBuilder: (context, imageProvider) => Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: widget.radius
                        ? BorderRadius.circular(5.0)
                        : BorderRadius.zero,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              ),
          placeholder: (context, url) => Container(),
          errorWidget: (context, url, error) => Container()),
    );
  }
}
