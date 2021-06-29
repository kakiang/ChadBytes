// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Article extends DataClass implements Insertable<Article> {
  final String link;
  final String title;
  final String thumbnail;
  final DateTime published;
  final String? summary;
  final String? content;
  final String? publisher;
  final bool? bookmarked;
  final bool? read;
  final String? audioLink;
  final String? videoLink;
  Article(
      {required this.link,
      required this.title,
      required this.thumbnail,
      required this.published,
      this.summary,
      this.content,
      this.publisher,
      this.bookmarked,
      this.read,
      this.audioLink,
      this.videoLink});
  factory Article.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Article(
      link: stringType.mapFromDatabaseResponse(data['${effectivePrefix}link'])!,
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      thumbnail: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}thumbnail'])!,
      published: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}published'])!,
      summary:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}summary']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      publisher: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}publisher']),
      bookmarked: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}bookmarked']),
      read: boolType.mapFromDatabaseResponse(data['${effectivePrefix}read']),
      audioLink: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}audio_link']),
      videoLink: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}video_link']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['link'] = Variable<String>(link);
    map['title'] = Variable<String>(title);
    map['thumbnail'] = Variable<String>(thumbnail);
    map['published'] = Variable<DateTime>(published);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String?>(summary);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String?>(content);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String?>(publisher);
    }
    if (!nullToAbsent || bookmarked != null) {
      map['bookmarked'] = Variable<bool?>(bookmarked);
    }
    if (!nullToAbsent || read != null) {
      map['read'] = Variable<bool?>(read);
    }
    if (!nullToAbsent || audioLink != null) {
      map['audio_link'] = Variable<String?>(audioLink);
    }
    if (!nullToAbsent || videoLink != null) {
      map['video_link'] = Variable<String?>(videoLink);
    }
    return map;
  }

  ArticlesCompanion toCompanion(bool nullToAbsent) {
    return ArticlesCompanion(
      link: Value(link),
      title: Value(title),
      thumbnail: Value(thumbnail),
      published: Value(published),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      bookmarked: bookmarked == null && nullToAbsent
          ? const Value.absent()
          : Value(bookmarked),
      read: read == null && nullToAbsent ? const Value.absent() : Value(read),
      audioLink: audioLink == null && nullToAbsent
          ? const Value.absent()
          : Value(audioLink),
      videoLink: videoLink == null && nullToAbsent
          ? const Value.absent()
          : Value(videoLink),
    );
  }

  factory Article.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Article(
      link: serializer.fromJson<String>(json['link']),
      title: serializer.fromJson<String>(json['title']),
      thumbnail: serializer.fromJson<String>(json['thumbnail']),
      published: serializer.fromJson<DateTime>(
          DateTime.parse(json['published']).millisecondsSinceEpoch),
      summary: serializer.fromJson<String?>(json['summary']),
      content: serializer.fromJson<String?>(json['content']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      bookmarked: serializer.fromJson<bool?>(json['bookmarked']),
      read: serializer.fromJson<bool?>(json['read']),
      audioLink: serializer.fromJson<String?>(json['audio_link']),
      videoLink: serializer.fromJson<String?>(json['video_link']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'link': serializer.toJson<String>(link),
      'title': serializer.toJson<String>(title),
      'thumbnail': serializer.toJson<String>(thumbnail),
      'published': serializer.toJson<DateTime>(published),
      'summary': serializer.toJson<String?>(summary),
      'content': serializer.toJson<String?>(content),
      'publisher': serializer.toJson<String?>(publisher),
      'bookmarked': serializer.toJson<bool?>(bookmarked),
      'read': serializer.toJson<bool?>(read),
      'audio_link': serializer.toJson<String?>(audioLink),
      'video_link': serializer.toJson<String?>(videoLink),
    };
  }

  Article copyWith(
          {String? link,
          String? title,
          String? thumbnail,
          DateTime? published,
          String? summary,
          String? content,
          String? publisher,
          bool? bookmarked,
          bool? read,
          String? audioLink,
          String? videoLink}) =>
      Article(
        link: link ?? this.link,
        title: title ?? this.title,
        thumbnail: thumbnail ?? this.thumbnail,
        published: published ?? this.published,
        summary: summary ?? this.summary,
        content: content ?? this.content,
        publisher: publisher ?? this.publisher,
        bookmarked: bookmarked ?? this.bookmarked,
        read: read ?? this.read,
        audioLink: audioLink ?? this.audioLink,
        videoLink: videoLink ?? this.videoLink,
      );
  @override
  String toString() {
    return (StringBuffer('Article(')
          ..write('link: $link, ')
          ..write('title: $title, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('published: $published, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('publisher: $publisher, ')
          ..write('bookmarked: $bookmarked, ')
          ..write('read: $read, ')
          ..write('audioLink: $audioLink, ')
          ..write('videoLink: $videoLink')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      link.hashCode,
      $mrjc(
          title.hashCode,
          $mrjc(
              thumbnail.hashCode,
              $mrjc(
                  published.hashCode,
                  $mrjc(
                      summary.hashCode,
                      $mrjc(
                          content.hashCode,
                          $mrjc(
                              publisher.hashCode,
                              $mrjc(
                                  bookmarked.hashCode,
                                  $mrjc(
                                      read.hashCode,
                                      $mrjc(audioLink.hashCode,
                                          videoLink.hashCode)))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Article &&
          other.link == this.link &&
          other.title == this.title &&
          other.thumbnail == this.thumbnail &&
          other.published == this.published &&
          other.summary == this.summary &&
          other.content == this.content &&
          other.publisher == this.publisher &&
          other.bookmarked == this.bookmarked &&
          other.read == this.read &&
          other.audioLink == this.audioLink &&
          other.videoLink == this.videoLink);
}

class ArticlesCompanion extends UpdateCompanion<Article> {
  final Value<String> link;
  final Value<String> title;
  final Value<String> thumbnail;
  final Value<DateTime> published;
  final Value<String?> summary;
  final Value<String?> content;
  final Value<String?> publisher;
  final Value<bool?> bookmarked;
  final Value<bool?> read;
  final Value<String?> audioLink;
  final Value<String?> videoLink;
  const ArticlesCompanion({
    this.link = const Value.absent(),
    this.title = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.published = const Value.absent(),
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.publisher = const Value.absent(),
    this.bookmarked = const Value.absent(),
    this.read = const Value.absent(),
    this.audioLink = const Value.absent(),
    this.videoLink = const Value.absent(),
  });
  ArticlesCompanion.insert({
    required String link,
    required String title,
    required String thumbnail,
    required DateTime published,
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.publisher = const Value.absent(),
    this.bookmarked = const Value.absent(),
    this.read = const Value.absent(),
    this.audioLink = const Value.absent(),
    this.videoLink = const Value.absent(),
  })  : link = Value(link),
        title = Value(title),
        thumbnail = Value(thumbnail),
        published = Value(published);
  static Insertable<Article> custom({
    Expression<String>? link,
    Expression<String>? title,
    Expression<String>? thumbnail,
    Expression<DateTime>? published,
    Expression<String?>? summary,
    Expression<String?>? content,
    Expression<String?>? publisher,
    Expression<bool?>? bookmarked,
    Expression<bool?>? read,
    Expression<String?>? audioLink,
    Expression<String?>? videoLink,
  }) {
    return RawValuesInsertable({
      if (link != null) 'link': link,
      if (title != null) 'title': title,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (published != null) 'published': published,
      if (summary != null) 'summary': summary,
      if (content != null) 'content': content,
      if (publisher != null) 'publisher': publisher,
      if (bookmarked != null) 'bookmarked': bookmarked,
      if (read != null) 'read': read,
      if (audioLink != null) 'audio_link': audioLink,
      if (videoLink != null) 'video_link': videoLink,
    });
  }

  ArticlesCompanion copyWith(
      {Value<String>? link,
      Value<String>? title,
      Value<String>? thumbnail,
      Value<DateTime>? published,
      Value<String?>? summary,
      Value<String?>? content,
      Value<String?>? publisher,
      Value<bool?>? bookmarked,
      Value<bool?>? read,
      Value<String?>? audioLink,
      Value<String?>? videoLink}) {
    return ArticlesCompanion(
      link: link ?? this.link,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      published: published ?? this.published,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      publisher: publisher ?? this.publisher,
      bookmarked: bookmarked ?? this.bookmarked,
      read: read ?? this.read,
      audioLink: audioLink ?? this.audioLink,
      videoLink: videoLink ?? this.videoLink,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (thumbnail.present) {
      map['thumbnail'] = Variable<String>(thumbnail.value);
    }
    if (published.present) {
      map['published'] = Variable<DateTime>(published.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String?>(summary.value);
    }
    if (content.present) {
      map['content'] = Variable<String?>(content.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String?>(publisher.value);
    }
    if (bookmarked.present) {
      map['bookmarked'] = Variable<bool?>(bookmarked.value);
    }
    if (read.present) {
      map['read'] = Variable<bool?>(read.value);
    }
    if (audioLink.present) {
      map['audio_link'] = Variable<String?>(audioLink.value);
    }
    if (videoLink.present) {
      map['video_link'] = Variable<String?>(videoLink.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticlesCompanion(')
          ..write('link: $link, ')
          ..write('title: $title, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('published: $published, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('publisher: $publisher, ')
          ..write('bookmarked: $bookmarked, ')
          ..write('read: $read, ')
          ..write('audioLink: $audioLink, ')
          ..write('videoLink: $videoLink')
          ..write(')'))
        .toString();
  }
}

class $ArticlesTable extends Articles with TableInfo<$ArticlesTable, Article> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ArticlesTable(this._db, [this._alias]);
  @override
  late final GeneratedTextColumn link = _constructLink();
  GeneratedTextColumn _constructLink() {
    return GeneratedTextColumn(
      'link',
      $tableName,
      false,
    );
  }

  @override
  late final GeneratedTextColumn title = _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  @override
  late final GeneratedTextColumn thumbnail = _constructThumbnail();
  GeneratedTextColumn _constructThumbnail() {
    return GeneratedTextColumn(
      'thumbnail',
      $tableName,
      false,
    );
  }

  @override
  late final GeneratedDateTimeColumn published = _constructPublished();
  GeneratedDateTimeColumn _constructPublished() {
    return GeneratedDateTimeColumn(
      'published',
      $tableName,
      false,
    );
  }

  @override
  late final GeneratedTextColumn summary = _constructSummary();
  GeneratedTextColumn _constructSummary() {
    return GeneratedTextColumn(
      'summary',
      $tableName,
      true,
    );
  }

  @override
  late final GeneratedTextColumn content = _constructContent();
  GeneratedTextColumn _constructContent() {
    return GeneratedTextColumn(
      'content',
      $tableName,
      true,
    );
  }

  @override
  late final GeneratedTextColumn publisher = _constructPublisher();
  GeneratedTextColumn _constructPublisher() {
    return GeneratedTextColumn(
      'publisher',
      $tableName,
      true,
    );
  }

  @override
  late final GeneratedBoolColumn bookmarked = _constructBookmarked();
  GeneratedBoolColumn _constructBookmarked() {
    return GeneratedBoolColumn('bookmarked', $tableName, true,
        defaultValue: const Constant(false));
  }

  @override
  late final GeneratedBoolColumn read = _constructRead();
  GeneratedBoolColumn _constructRead() {
    return GeneratedBoolColumn('read', $tableName, true,
        defaultValue: const Constant(false));
  }

  @override
  late final GeneratedTextColumn audioLink = _constructAudioLink();
  GeneratedTextColumn _constructAudioLink() {
    return GeneratedTextColumn(
      'audio_link',
      $tableName,
      true,
    );
  }

  @override
  late final GeneratedTextColumn videoLink = _constructVideoLink();
  GeneratedTextColumn _constructVideoLink() {
    return GeneratedTextColumn(
      'video_link',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        link,
        title,
        thumbnail,
        published,
        summary,
        content,
        publisher,
        bookmarked,
        read,
        audioLink,
        videoLink
      ];
  @override
  $ArticlesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'articles';
  @override
  final String actualTableName = 'articles';
  @override
  Set<GeneratedColumn> get $primaryKey => {link};
  @override
  Article map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Article.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ArticlesTable createAlias(String alias) {
    return $ArticlesTable(_db, alias);
  }
}

class FtsIdxData extends DataClass implements Insertable<FtsIdxData> {
  final String link;
  final String title;
  final String summary;
  FtsIdxData({required this.link, required this.title, required this.summary});
  factory FtsIdxData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return FtsIdxData(
      link: stringType.mapFromDatabaseResponse(data['${effectivePrefix}link'])!,
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      summary: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}summary'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['link'] = Variable<String>(link);
    map['title'] = Variable<String>(title);
    map['summary'] = Variable<String>(summary);
    return map;
  }

  FtsIdxCompanion toCompanion(bool nullToAbsent) {
    return FtsIdxCompanion(
      link: Value(link),
      title: Value(title),
      summary: Value(summary),
    );
  }

  factory FtsIdxData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return FtsIdxData(
      link: serializer.fromJson<String>(json['link']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String>(json['summary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'link': serializer.toJson<String>(link),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String>(summary),
    };
  }

  FtsIdxData copyWith({String? link, String? title, String? summary}) =>
      FtsIdxData(
        link: link ?? this.link,
        title: title ?? this.title,
        summary: summary ?? this.summary,
      );
  @override
  String toString() {
    return (StringBuffer('FtsIdxData(')
          ..write('link: $link, ')
          ..write('title: $title, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(link.hashCode, $mrjc(title.hashCode, summary.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is FtsIdxData &&
          other.link == this.link &&
          other.title == this.title &&
          other.summary == this.summary);
}

class FtsIdxCompanion extends UpdateCompanion<FtsIdxData> {
  final Value<String> link;
  final Value<String> title;
  final Value<String> summary;
  const FtsIdxCompanion({
    this.link = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
  });
  FtsIdxCompanion.insert({
    required String link,
    required String title,
    required String summary,
  })   : link = Value(link),
        title = Value(title),
        summary = Value(summary);
  static Insertable<FtsIdxData> custom({
    Expression<String>? link,
    Expression<String>? title,
    Expression<String>? summary,
  }) {
    return RawValuesInsertable({
      if (link != null) 'link': link,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
    });
  }

  FtsIdxCompanion copyWith(
      {Value<String>? link, Value<String>? title, Value<String>? summary}) {
    return FtsIdxCompanion(
      link: link ?? this.link,
      title: title ?? this.title,
      summary: summary ?? this.summary,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FtsIdxCompanion(')
          ..write('link: $link, ')
          ..write('title: $title, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }
}

class FtsIdx extends Table
    with TableInfo<FtsIdx, FtsIdxData>, VirtualTableInfo<FtsIdx, FtsIdxData> {
  final GeneratedDatabase _db;
  final String? _alias;
  FtsIdx(this._db, [this._alias]);
  late final GeneratedTextColumn link = _constructLink();
  GeneratedTextColumn _constructLink() {
    return GeneratedTextColumn('link', $tableName, false,
        $customConstraints: '');
  }

  late final GeneratedTextColumn title = _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn('title', $tableName, false,
        $customConstraints: '');
  }

  late final GeneratedTextColumn summary = _constructSummary();
  GeneratedTextColumn _constructSummary() {
    return GeneratedTextColumn('summary', $tableName, false,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns => [link, title, summary];
  @override
  FtsIdx get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'fts_idx';
  @override
  final String actualTableName = 'fts_idx';
  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  FtsIdxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return FtsIdxData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  FtsIdx createAlias(String alias) {
    return FtsIdx(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(link UNINDEXED, title, summary, content=articles)';
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $ArticlesTable articles = $ArticlesTable(this);
  late final FtsIdx ftsIdx = FtsIdx(this);
  late final Trigger articlesAi = Trigger(
      'CREATE TRIGGER articles_ai AFTER INSERT ON articles BEGIN\n  INSERT INTO fts_idx(rowid, link, title, summary) VALUES (new.rowid, new.link, new.title, new.summary);\nEND;',
      'articles_ai');
  late final Trigger articlesAd = Trigger(
      'CREATE TRIGGER articles_ad AFTER DELETE ON articles BEGIN\n  INSERT INTO fts_idx(fts_idx, rowid, link, title, summary) VALUES(\'delete\', old.rowid, old.link, old.title, old.summary);\nEND;',
      'articles_ad');
  late final Trigger articlesAu = Trigger(
      'CREATE TRIGGER articles_au AFTER UPDATE ON articles BEGIN\n  INSERT INTO fts_idx(fts_idx, rowid, link, title, summary) VALUES(\'delete\', old.rowid, old.link, old.title, old.summary);\n  INSERT INTO fts_idx(rowid, link, title, summary) VALUES (new.rowid, new.link, new.title, new.summary);\nEND;',
      'articles_au');
  Selectable<FtsIdxData> _articlesWithFts5(String var1) {
    return customSelect(
        'SELECT * FROM fts_idx WHERE fts_idx MATCH ? ORDER BY rank',
        variables: [Variable<String>(var1)],
        readsFrom: {ftsIdx}).map(ftsIdx.mapFromRow);
  }

  Selectable<int> _countArticles() {
    return customSelect('SELECT COUNT(*) FROM articles',
        variables: [],
        readsFrom: {articles}).map((QueryRow row) => row.readInt('COUNT(*)'));
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [articles, ftsIdx, articlesAi, articlesAd, articlesAu];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('articles',
                limitUpdateKind: UpdateKind.insert),
            result: [
              TableUpdate('fts_idx', kind: UpdateKind.insert),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('articles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('fts_idx', kind: UpdateKind.insert),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('articles',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('fts_idx', kind: UpdateKind.insert),
            ],
          ),
        ],
      );
}
