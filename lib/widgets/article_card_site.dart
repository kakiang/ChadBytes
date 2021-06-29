import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geschehen/model/database.dart';

class ArticleCardSite extends StatelessWidget {
  final Article article;
  const ArticleCardSite(this.article, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var publisher = article.publisher ?? article.link;
    var iconUrl =
        'https://www.google.com/s2/favicons?sz=64&domain=${Uri.parse(publisher).host}';
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: iconUrl,
            imageBuilder: (context, imageProvider) => Container(
              margin: EdgeInsets.only(right: 4.0),
              width: 16.0,
              height: 16.0,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(1.0),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.fill)),
            ),
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => Container(),
          ),
          Text(Uri.parse(article.link).authority.replaceFirst('www.', ''),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2),
        ]);
  }
}
