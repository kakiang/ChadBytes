import 'package:flutter/material.dart';
import 'package:geschehen/pages/article_content_display.dart';
import 'package:geschehen/service/article_service.dart';
import 'package:geschehen/model/database.dart';
import 'package:geschehen/widgets/article_card.dart';
import 'package:geschehen/widgets/article_card_top_news.dart';
import 'package:provider/provider.dart';

class ArticleSliverList extends StatefulWidget {
  final bool bookmarkPage;
  const ArticleSliverList(this.bookmarkPage, {Key? key}) : super(key: key);

  @override
  _ArticleSliverListState createState() => _ArticleSliverListState();
}

class _ArticleSliverListState extends State<ArticleSliverList> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ArticleService>(context);
    var dismissibleBackground = Container(
      color: Colors.red.shade400,
      padding: EdgeInsets.all(16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.delete_outline_rounded,
          size: 32,
          color: Colors.black87,
        ),
        Icon(
          Icons.delete_outline_rounded,
          size: 32,
          color: Colors.black87,
        ),
      ]),
    );
    return SliverList(
      delegate: SliverChildListDelegate([
        !widget.bookmarkPage
            ? StreamBuilder<Article>(
                stream: bloc.topNews,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    Article article = snapshot.data!;
                    return Dismissible(
                      background: dismissibleBackground,
                      secondaryBackground: dismissibleBackground,
                      onDismissed: (DismissDirection direction) async {
                        await bloc.deleteArticle(article.link);
                      },
                      key: Key(article.link),
                      child: InkWell(
                          onTap: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ArticleContent(article);
                                },
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 8.0, 8.0, 0.0),
                                child: article.thumbnail.isNotEmpty
                                    ? TopNewsArticleCard(article)
                                    : ArticleCard(article),
                              ),
                              Divider(height: 0.0)
                            ],
                          )),
                    );
                  }
                  return Container();
                })
            : Container(),
        StreamBuilder<List<Article>>(
            stream: widget.bookmarkPage
                ? bloc.bookmarkedArticleStream
                : bloc.articleStream,
            initialData: List.empty(),
            builder: (context, snapshot) {
              debugPrint("!!!snapshot state: ${snapshot.connectionState}!!!");
              if (snapshot.hasData && snapshot.data != null) {
                List<Article> data = snapshot.data!;
                var length = data.length;
                return ListView.separated(
                    padding: EdgeInsets.only(bottom: 8.0),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(height: 0.0),
                    itemBuilder: (BuildContext context, int index) {
                      Article article = data.elementAt(index);
                      return Dismissible(
                        onDismissed: (DismissDirection direction) async {
                          await bloc.deleteArticle(article.link);
                        },
                        background: dismissibleBackground,
                        secondaryBackground: dismissibleBackground,
                        key: Key(article.link),
                        child: InkWell(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ArticleCard(article)),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ArticleContent(article);
                            }));
                          },
                          onLongPress: () async {
                            await bloc.deleteArticle(article.link);
                          },
                        ),
                      );
                    });
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator();
              } else {
                debugPrint("!!!snapshot error ${snapshot.error?.toString()}");
                return Center(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    width: 20,
                    height: 20,
                    child: ErrorWidget("An error has occured"),
                  ),
                );
              }
            }),
      ]),
    );
  }
}
