import 'package:geschehen/model/database.dart';
import 'package:flutter/material.dart';
import 'package:geschehen/widgets/article_thumbnail.dart';
import 'package:geschehen/widgets/article_card_site.dart';

import 'article_card_bottom.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard(this.article, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
                    child: ArticleCardSite(article),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(2.0),
                    title: Text(
                      article.title,
                      softWrap: true,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8.0),
              child: ArticleThumbnail(article.thumbnail, width: 124.0, height: 86.0),
            ),
          ],
        ),
        Padding(
          padding:
              EdgeInsets.only(top: article.thumbnail.length > 0 ? 4.0 : 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [ArticleCardTime(article), ArticleCardBookmark(article)],
          ),
        )
      ],
    );
  }
}
