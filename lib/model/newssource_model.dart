class NewsSource {
  final String name;
  final String url;
  final String iconUrl;
  bool starred;

   NewsSource(
      {required this.name,
      required this.url,
      required this.iconUrl,
      this.starred = true});
}

final newsSourceList = [
   NewsSource(
      name: "African News Agency",
      url: "https://www.africannewsagency.com/",
      iconUrl: 'https://www.enca.com/sites/default/files/3600130208.jpg',
      starred: true),
   NewsSource(
      name: "AllAfrica.com",
      url: "https://allafrica.com",
      iconUrl: 'https://allafrica.com/static/images/structure/aa-logo.png',
      starred: true),
  NewsSource(
      name: "BBC News",
      url: "bbc.co.uk",
      iconUrl: 'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif',
      starred: true),
  NewsSource(
      name: "VOA News",
      url: "https://www.voanews.com",
      iconUrl:
          'https://www.voanews.com/Content/responsive/VOA/en-US/img/logo.png',
      starred: true),
  NewsSource(
      name: "RFI",
      url: "http://www.rfi.fr/",
      iconUrl:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Rfi_logo.svg/65px-Rfi_logo.svg.png",
      starred: false),
  NewsSource(
      name: "CNN",
      url: "http://www.cnn.com/",
      iconUrl:
          'http://cdn.cnn.com/cnn/.e1mo/img/4.0/logos/logo_cnn_badge_2up.png',
      starred: true),
  NewsSource(
      name: "Africanews",
      url: "http://www.africanews.com/",
      iconUrl:
          'https://www.businessforafricaforum.com/wp-content/uploads/2017/11/Africanews_logo_coul_370x270-400x300.png',
      starred: true),
];
