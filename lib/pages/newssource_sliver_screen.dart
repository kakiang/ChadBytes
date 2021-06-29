import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geschehen/model/newssource_model.dart';
import 'package:geschehen/utils/util.dart';

class NewsSourceSliverList extends StatefulWidget {
  @override
  _NewsSourceSliverListState createState() => _NewsSourceSliverListState();
}

class _NewsSourceSliverListState extends State<NewsSourceSliverList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        newsSourceList.map<Widget>((NewsSource agency) {
          return Column(
            children: [agencyListTile(agency), Divider(height: 20.0)],
          );
        }).toList(),
      ),
    );
  }

  Widget agencyListTile(NewsSource agency) {
    return ListTile(
      leading: Container(
        width: 48.0,
        height: 48.0,
        child: CachedNetworkImage(
            imageUrl: agency.iconUrl,
            imageBuilder: (context, imageProvider) => Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                      image: DecorationImage(image: imageProvider)),
                ),
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => Container()),
      ),
      title: InkWell(
        child: Text(agency.name),
        onTap: () async => launchURL(agency.url),
      ),
      trailing: GestureDetector(
        onTap: () {
          setState(() {
            agency.starred = !agency.starred;
          });
        },
        child: Container(
            alignment: Alignment.center,
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(width: 0.7, color: Theme.of(context).dividerColor),
            ),
            child: Icon(
              agency.starred ? Icons.star : Icons.star_border,
              color: agency.starred
                  ? Theme.of(context).accentColor
                  : Theme.of(context).iconTheme.color,
            )),
      ),
    );
  }
}
