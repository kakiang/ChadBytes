// Utility class that decides whether we should fetch some data or not.

import 'package:shared_preferences/shared_preferences.dart';

class RateLimiter {
  static final RateLimiter _rateLimiter = RateLimiter._internal();

  factory RateLimiter() {
    return _rateLimiter;
  }

  RateLimiter._internal();

  Future<bool> shouldFetch({int timeoutInMillisecons = 30 * 1000}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastFetch = prefs.getInt('lastFetch') ?? 0;

    var now = DateTime.now().millisecondsSinceEpoch;

    var since = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastFetch))
        .inSeconds;

    if (lastFetch == 0 || now - lastFetch >= timeoutInMillisecons) {
      print("shouldFetch? Yes - lastFetched $since sec ago");
      lastFetch = now;
      await prefs.setInt('lastFetch', lastFetch);
      return true;
    }

    print('shouldFetch? No -lastFetched $since seconds ago');
    return false;
  }

  Future<bool> reset() async {
    return (await SharedPreferences.getInstance()).setInt('lastFetch', 0);
  }
}

RateLimiter getRateLimiter = RateLimiter();
