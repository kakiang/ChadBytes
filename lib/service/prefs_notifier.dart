import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsNotifier with ChangeNotifier {
  bool _notif = true;

  bool getNotif() => _notif;

  PrefsNotifier() {
     _loadSharedPrefs();
    print('PrefsNotifier() _notif=$_notif');
  }


  Future _loadSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("notif") != null) {
      _notif = prefs.getBool("notif")!;
    } else {
      prefs.setBool("notif", true);
    }
    notifyListeners();
  }

  saveNewPrefs(bool val) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("notif", val);
      _notif = val;
      print('saveNewPrefs _notif=$_notif');
      notifyListeners();
    });
  }
}
