// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class ArticleListScreen extends StatefulWidget {
//   ArticleListScreen({Key? key}) : super(key: key);

//   @override
//   _ArticleListScreenState createState() => _ArticleListScreenState();
// }

// class _ArticleListScreenState extends State<ArticleListScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SmartRefresher(
//           enablePullDown: true,
//           header: ClassicHeader(
//             refreshingText: "",
//             releaseText: "",
//             completeText: "",
//             idleText: "",
//           ),
//           controller: _refreshController,
//           onRefresh: _onRefresh,
//           onLoading: _onLoading,
//           child: CustomScrollView(slivers:[_pages.values.elementAt(_selectedIndex)]),
//         );
//   }
// }