import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

String timeElapsedSince(DateTime date) {
  // var formatter = DateFormat("EEE, d MMM yyyy HH:mm:ss zzz");

  // DateTime parsedDate = formatter.parse(date);
  Duration duration = DateTime.now().difference(date);

  if (duration.inDays > 7 || duration.isNegative) {
    return DateFormat.MMMMd().format(date);
  } else if (duration.inDays >= 1 && duration.inDays <= 7) {
    return duration.inDays == 1 ? "1day ago" : "${duration.inDays}  days ago";
  } else if (duration.inHours >= 1) {
    return duration.inHours == 1 ? "1h ago" : "${duration.inHours}h ago";
  } else {
    return duration.inMinutes == 1 ? "1m ago" : "${duration.inMinutes}m ago";
  }
}

var apiURL = "insert api url here";

void launchURL(String link) async {
  try {
    await launch(link);
  } catch (e) {
    print('=== _launchURL:ERRRRR ${e.toString()}');
  }
}
