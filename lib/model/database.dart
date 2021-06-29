import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/ffi.dart';
import 'dart:io';

part 'database.g.dart';

@DataClassName("Article")
class Articles extends Table {
  TextColumn get link => text()();
  TextColumn get title => text()();
  TextColumn get thumbnail => text()();
  DateTimeColumn get published => dateTime()();
  TextColumn get summary => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get publisher => text().nullable()();
  BoolColumn get bookmarked =>
      boolean().withDefault(const Constant(false)).nullable()();
  BoolColumn get read =>
      boolean().withDefault(const Constant(false)).nullable()();
  @JsonKey('audio_link')
  TextColumn get audioLink => text().nullable()();
  @JsonKey('video_link')
  TextColumn get videoLink => text().nullable()();

  @override
  Set<Column> get primaryKey => {link};
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(
  tables: [Articles],
  include: {'fts.moor'},
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Future<int> count() async {
    return await (_countArticles().getSingle());
  }

  Future<Article> getArticleByLink(String link) {
    return (select(articles)..where((t) => t.link.equals(link))).getSingle();
  }

  Future deleteArticle(String link) {
    return (delete(articles)..where((t) => t.link.equals(link))).go();
  }

  Future<List<Article>> get allArticles =>
      (select(articles)..orderBy([(e) => OrderingTerm.desc(e.published)]))
          .get();

  Future<List<Article>> getArticleByLinks(List<String> links) {
    return (select(articles)
          ..where((e) => e.link.isIn(links))
          ..orderBy([(e) => OrderingTerm.desc(e.published)]))
        .get();
  }

  Stream<List<Article>> get bookmarkedArticleStream => (select(articles)
        ..where((t) => t.bookmarked.equals(true))
        ..orderBy([(e) => OrderingTerm.desc(e.published)]))
      .watch();

  Stream<List<Article>> get articleStream => (select(articles)
        ..where((e) => e.title.length.isBiggerThanValue(1))
        ..orderBy([(e) => OrderingTerm.desc(e.published)])
        ..limit(100, offset: 1))
      .watch();

  Stream<List<Article>> watchArticlesInPublisher(String publisher) {
    return (select(articles)..where((t) => t.publisher.equals(publisher)))
        .watch();
  }

  Stream<Article> get topNews => (select(articles)
        ..orderBy([(e) => OrderingTerm.desc(e.published)])
        ..limit(1))
      .watchSingle();

  Future<int> addArticle(ArticlesCompanion entry) {
    return into(articles).insertOnConflictUpdate(entry);
  }

  Future<int> insert(Article entry) {
    return into(articles).insertOnConflictUpdate(entry);
  }

  Future insertMany(List<Article> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(articles, list);
    });
  }

  Future<int> updateBookmark(String link, bool bookmarked) {
    return (update(articles)..where((e) => e.link.equals(link)))
        .write(ArticlesCompanion(bookmarked: Value(bookmarked)));
  }

  Future<int> updateRead(String link, bool read) {
    return (update(articles)..where((e) => e.link.equals(link)))
        .write(ArticlesCompanion(read: Value(read)));
  }

  Future<List<FtsIdxData>> ftsIdxData(String query) {
    return _articlesWithFts5(query).get();
  }

  Future<List<Article>> ftsResults(String query) async {
    var ftsIdxList = await ftsIdxData(query);
    print("ftsResults: ${ftsIdxList.length}");
    var links = ftsIdxList.map((e) => e.link);
    var articles = getArticleByLinks(List.from(links));
    return articles;
  }
}
