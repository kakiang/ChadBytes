import 'package:flutter/material.dart';
import 'package:geschehen/model/database.dart';
import 'package:geschehen/service/article_service.dart';
import 'package:geschehen/utils/util.dart';
import 'package:provider/provider.dart';

class ArticleCardTime extends StatelessWidget {
  final Article article;

  const ArticleCardTime(this.article, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(timeElapsedSince(article.published),
            style: Theme.of(context).textTheme.subtitle2),
        if (article.read ?? false)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              Icons.remove_red_eye_outlined,
              size: 18,
              semanticLabel: 'isRead',
            ),
          ),
      ],
    );
  }
}

class ArticleCardBookmark extends StatefulWidget {
  final Article article;

  const ArticleCardBookmark(this.article, {Key? key}) : super(key: key);

  @override
  _ArticleCardBookmarkState createState() => _ArticleCardBookmarkState();
}

class _ArticleCardBookmarkState extends State<ArticleCardBookmark> {
  @override
  Widget build(BuildContext context) {
    bool bookmarked = widget.article.bookmarked ?? false;
    return Row(
      children: [
        if (widget.article.audioLink != null &&
            widget.article.audioLink!.isNotEmpty)
          IconButton(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              icon: Icon(Icons.play_circle_outline_rounded,
                  semanticLabel: 'play audio'),
              onPressed: () => {}),
        Consumer<ArticleService>(
          builder: (context, bloc, _) => IconButton(
            iconSize: 24.0,
            icon: Icon(
              bookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              semanticLabel: 'bookmark',
            ),
            onPressed: () async {
              await bloc.updateBookmark(widget.article.link, !bookmarked);
              setState(() {
                bookmarked = !bookmarked;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("${bookmarked ? 'Saved' : "Removed"}")));
            },
          ),
        ),
      ],
    );
  }
}
