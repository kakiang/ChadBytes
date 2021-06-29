import 'package:flutter/material.dart';
import 'package:geschehen/model/database.dart';
import 'package:geschehen/widgets/article_card_site.dart';

import 'article_thumbnail.dart';
import 'article_card_bottom.dart';

class TopNewsArticleCard extends StatelessWidget {
  final Article article;
  const TopNewsArticleCard(this.article, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ArticleThumbnail(article.thumbnail,
            width: MediaQuery.of(context).size.width, height: 214.0),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
          title: Text(
            article.title,
            softWrap: true,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style:
                Theme.of(context).textTheme.headline4?.copyWith(fontSize: 22),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ArticleCardSite(article),
              ArticleCardTime(article),
              ArticleCardBookmark(article)
            ],
          ),
        ),
      ],
    );
  }
}
