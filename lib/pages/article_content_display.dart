import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:geschehen/model/database.dart';
import 'package:geschehen/service/article_service.dart';
import 'package:geschehen/service/download_notifier.dart';
import 'package:geschehen/utils/util.dart';
import 'package:geschehen/widgets/article_card_bottom.dart';
import 'package:geschehen/widgets/article_card_site.dart';
import 'package:geschehen/widgets/article_thumbnail.dart';
import 'package:geschehen/widgets/player_widget.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ArticleContent extends StatefulWidget {
  final Article article;
  const ArticleContent(this.article, {Key? key}) : super(key: key);

  @override
  _ArticleContentState createState() => _ArticleContentState();
}

class _ArticleContentState extends State<ArticleContent> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String? localFilePath;

  Future _getLocalFile() async {
    var file = await getLocalFile(widget.article.audioLink!.split('/').last);
    setState(() {
      localFilePath = file;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocalFile();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ArticleService>(context);
    bool bookmarked = widget.article.bookmarked ?? false;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backwardsCompatibility: false,
            floating: true,
            snap: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, semanticLabel: 'goback'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            actions: <Widget>[
              IconButton(
                  padding: EdgeInsets.only(right: 8.0),
                  icon: Icon(Icons.share, semanticLabel: 'share'),
                  onPressed: () {
                    Share.share('${widget.article.link}',
                        subject: widget.article.title);
                  }),
              IconButton(
                  iconSize: 24.0,
                  icon: Icon(
                      bookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      semanticLabel: 'bookmark'),
                  onPressed: () async {
                    await bloc.updateBookmark(widget.article.link, !bookmarked);
                    setState(() {
                      bookmarked = !bookmarked;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("${bookmarked ? 'Saved' : "Removed"}")));
                  }),
              IconButton(
                  padding: EdgeInsets.only(right: 12.0, left: 12.0),
                  icon: Icon(Icons.open_in_browser,
                      semanticLabel: 'open in browser'),
                  onPressed: () async => launchURL(widget.article.link)),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.article.title,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontSize: 26),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ArticleCardSite(widget.article),
                        ArticleCardTime(widget.article)
                      ],
                    ))
              ]),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.article.thumbnail.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ArticleThumbnail(widget.article.thumbnail,
                      width: MediaQuery.of(context).size.width,
                      height: 256.0,
                      radius: false),
                ),
              if (widget.article.audioLink != null &&
                  widget.article.audioLink!.isNotEmpty)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                      child: PlayerWidget(
                          article: widget.article,
                          url: widget.article.audioLink!),
                    ),
                    Divider(height: 8.0),
                  ],
                ),
            ],
          )),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 32),
              child: HtmlDisplay(article: widget.article),
            ),
          ),
        ],
      ),
    );
  }
}

class HtmlDisplay extends StatefulWidget {
  const HtmlDisplay({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  _HtmlDisplayState createState() => _HtmlDisplayState();
}

class _HtmlDisplayState extends State<HtmlDisplay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!(widget.article.read ?? false)) {
      Provider.of<ArticleService>(context)
          .updateRead(widget.article.link, true);
    }
    return Html(
      data: widget.article.content ?? "",
      style: {
        "*": Style(
            lineHeight: LineHeight.percent(120),
            fontSize: FontSize.xLarge,
            fontFamily: "Lumin-Serif",
            fontWeight: FontWeight.w400),
        "br": Style(
            display: Display.BLOCK,
            padding: EdgeInsets.symmetric(vertical: 24.0)),
        "p": Style(
            display: Display.BLOCK,
            margin: EdgeInsets.symmetric(vertical: 18.0)),
        "div": Style(
            display: Display.BLOCK,
            margin: EdgeInsets.symmetric(vertical: 18.0)),
        "strong, .lead": Style(fontWeight: FontWeight.w600),
        "h2, h3, h4": Style(
          fontWeight: FontWeight.w600,
          textDecoration: TextDecoration.underline,
        ),
        ".m-em-quote__body__picto": Style(
            display: Display.BLOCK,
            padding: EdgeInsets.symmetric(vertical: 12.0),
            fontStyle: FontStyle.italic,
            before: '"',
            after: '"'),
      },
      onLinkTap: (String? url, context, attributes, element) {
        if (url != null && url.isNotEmpty) {
          launchURL(url);
        }
      },
    );
  }
}
