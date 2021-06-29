import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geschehen/pages/article_sliver_screen.dart';
import 'package:geschehen/pages/newssource_sliver_screen.dart';
import 'package:geschehen/service/article_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'article_search_delegate.dart';
import 'settings_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static const String routeName = '/home';
  // final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  //  bool get didNotificationLaunchApp =>
  //     notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ScrollController _homeController = ScrollController();

  RefreshController _refreshController = RefreshController();

  late ArticleService _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = Provider.of<ArticleService>(context, listen: false);

    var notificationAppLaunchDetails =
        context.read<NotificationAppLaunchDetails?>();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      _onRefresh();
    }
    // if (mounted) _refreshController.requestRefresh();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    // monitor network fetch
    if (mounted) await _bloc.refresh();
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    if (mounted) _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    if (mounted) _refreshController.loadComplete();
  }

  var _pages = {
    "Home": ArticleSliverList(false),
    "Bookmark": ArticleSliverList(true),
    "Newsstands": NewsSourceSliverList(),
  };

  // Widget mainView() {
  //   if (_selectedIndex == 0) {
  //     return ArticleSliverList(false);
  //   } else if (_selectedIndex == 1) {
  //     return ArticleSliverList(true);
  //   } else if (_selectedIndex == 2) {
  //     return NewsAgencySliverList();
  //   } else {
  //     return SliverPadding(
  //       padding: EdgeInsets.all(16.0),
  //     );
  //   }
  // }

  void _onTap(int index) {
    if (index < 2) {
      _homeController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 700),
      );
    }
    if (mounted)
      setState(() {
        _selectedIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _homeController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backwardsCompatibility: false,
              floating: true,
              snap: true,
              title: Text(
                "CHAD bytes",
                style: GoogleFonts.montserratSubrayada(
                  color: Colors.redAccent.shade200,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  // textStyle: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  iconSize: 28.0,
                  padding: EdgeInsets.only(right: 8.0),
                  icon: Icon(Icons.search, semanticLabel: 'search'),
                  onPressed: () async {
                    await showSearch(
                      context: context,
                      delegate: ArticleSearchDelegate(),
                    );
                  },
                ),
                IconButton(
                  iconSize: 28.0,
                  padding: EdgeInsets.only(right: 8.0),
                  icon: Icon(Icons.tune_rounded, semanticLabel: 'setting'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SettingScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ];
        },
        body: SmartRefresher(
          enablePullDown: true,
          header: ClassicHeader(
            refreshingText: "",
            releaseText: "",
            completeText: "",
            idleText: "",
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: CustomScrollView(
              slivers: [_pages.values.elementAt(_selectedIndex)]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _onTap(index),
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Text("CB",
                style: GoogleFonts.montserratSubrayada(
                    color: _selectedIndex == 0
                        ? Theme.of(context).accentColor
                        : Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 24)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? Icons.bookmarks_sharp
                : Icons.bookmarks_outlined),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2
                ? Icons.source_sharp
                : Icons.source_outlined),
            label: 'Sources',
          ),
        ],
      ),
    );
  }
}
