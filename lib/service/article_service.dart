import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:geschehen/model/database.dart';
import 'package:geschehen/utils/rate_limiter.dart';
import 'package:geschehen/utils/util.dart';
import 'package:http/http.dart' as http;

class ArticleService {
  late AppDb database;
  RateLimiter rateLimit = getRateLimiter;

  ArticleService({required AppDb db}) {
    database = db;
    _init();
  }

  Future<void> _init() async {
    await refresh();
  }

  Future<void> refresh() async {
    print(':::refresh:::');
    if (await rateLimit.shouldFetch()) {
      await _fetchFromNetwork();
    }
  }

  FutureOr fetchFromNetwork() async {
    await _fetchFromNetwork();
  }

  Future<List<Article>> _fetchFromNetwork() async {
    print('==== _fetchFromNetwork ===== $apiURL');
    List<Article> articles = [];
    var url = Uri.parse(apiURL);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable json = convert.jsonDecode(response.body);

        articles = List<Article>.from(json.map((e) {
          var a = Article.fromJson(e);
          insert(a);
          return a;
        }));
        // articles = List<Article>.from(json.map((e) => Article.fromJson(e)));
        // List<Article>.from(json.map((e) => Article.fromJson(e["doc"])));

        debugPrint('articles.length ${articles.length.toString()}');
        // await saveResult(articles);
      } else {
        rateLimit.reset();
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      rateLimit.reset();
      debugPrint('=== _fetchFromNetwork Error ${e.toString()}');
    }

    if (!await count()) {
      rateLimit.reset();
    }
    return articles;
  }

  Future saveResult(List<Article> articles) async {
    try {
      await database.insertMany(articles);
    } catch (e) {
      debugPrint("saveResult: ${e.toString()}");
    }
  }

  Future<int> insert(Article entry) async {
    return await database.insert(entry);
  }

  Stream<List<Article>> get articleStream => database.articleStream;
  Stream<Article> get topNews => database.topNews;
  Stream<List<Article>> get bookmarkedArticleStream =>
      database.bookmarkedArticleStream;

  Future<int> deleteArticle(String link) async {
    return await database.deleteArticle(link);
  }

  Future<int> updateBookmark(String link, bool bookmarked) async {
    return await database.updateBookmark(link, bookmarked);
  }

  Future<int> updateRead(String link, bool read) async {
    return await database.updateRead(link, read);
  }

  Future<List<Article>> ftsResults(String query) async {
    return await database.ftsResults(query);
  }

  Future<bool> count() async {
    var count = await database.count();
    if (count > 0) {
      return true;
    }
    return false;
  }
}
