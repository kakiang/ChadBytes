import 'package:flutter/material.dart';
import 'package:geschehen/model/database.dart';
import 'package:geschehen/service/article_service.dart';
import 'package:geschehen/widgets/article_card.dart';
import 'package:provider/provider.dart';

import 'article_content_display.dart';

class ArticleSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<ArticleService>(
      builder: (context, bloc, _) => FutureBuilder<List<Article>>(
          future: bloc.ftsResults(query),
          initialData: List.empty(),
          builder: (context, snapshot) {
            debugPrint("SEARCHDELEGATE:STATE ${snapshot.connectionState}");
            if (snapshot.hasData && snapshot.data!.length > 0) {
              List<Article> data = snapshot.data!;
              var length = data.length;
              debugPrint("SEARCHDELEGATE: $length");
              return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 0.0),
                  itemBuilder: (BuildContext context, int index) {
                    Article article = data.elementAt(index);
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ArticleContent(article);
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ArticleCard(article),
                      ),
                    );
                  });
            } else {
              debugPrint("SEARCHDELEGATE else ${snapshot.error?.toString()}");
              return Center(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, size: 72.0),
                      Text('No matches for "$query"'),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    showSuggestions(context);
    return Container();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
        border: InputBorder.none,
      ),
    );
  }
}
