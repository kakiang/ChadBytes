import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geschehen/service/prefs_notifier.dart';
import 'package:geschehen/theme.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  static const String routeName = '/setting';

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _radioGroupValue = '';
  // bool notif = true;
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  @override
  void initState() {
    super.initState();
    _radioGroupValue = 'dark';
    _initPackageInfo();

    // SharedPreferences.getInstance().then((prefs) {
    //   setState(() {
    //     notif = prefs.getBool("notif") ?? true;
    //   });
    //   print('initState notif=$notif');
    // });
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  subscribe(bool isChecked, PrefsNotifier prefs) async {
    print("Notifications subscribe: isChecked=$isChecked");
    prefs.saveNewPrefs(isChecked);
    isChecked
        ? await FirebaseMessaging.instance.subscribeToTopic('newsUpdate')
        : await FirebaseMessaging.instance.unsubscribeFromTopic('newsUpdate');
  }

  @override
  Widget build(BuildContext context) {
    // final prefsNotif = Provider.of<PrefsNotifier>(context);
    // bool notif = prefsNotif.getNotif();
    return Scaffold(
      appBar: AppBar(backwardsCompatibility: false, title: Text("Settings")),
      body: ListView(
        shrinkWrap: true,
        children: [
          Consumer<AppThemeNotifier>(
            builder: (context, themeState, _) => SwitchListTile(
                secondary: Icon(Icons.nightlight_round),
                title: Text("Dark theme"),
                value: themeState.isDarkTheme(),
                onChanged: (isChecked) {
                  isChecked
                      ? themeState.setDarkMode()
                      : themeState.setLightMode();
                  print(" Switch NewVal: $isChecked");
                }),
          ),
          Consumer<PrefsNotifier>(
            builder: (context, prefsNotif, _) => SwitchListTile(
                secondary: Icon(Icons.notifications),
                title: Text("Notifications"),
                value: prefsNotif.getNotif(),
                onChanged: (isChecked) async {
                  await subscribe(isChecked, prefsNotif);
                }),
          ),
          ListTile(
              leading: Icon(Icons.info),
              title: Text('About ${_packageInfo.appName}'),
              onTap: () {
                return showAboutDialog(
                    context: context,
                    applicationName: _packageInfo.appName,
                    applicationVersion:
                        "${_packageInfo.version}.${_packageInfo.buildNumber}",
                    applicationIcon: Image.asset(
                      'assets/images/logo.png',
                      alignment: Alignment.topCenter,
                      height: 36.0,
                      width: 36.0,
                    ),
                    children: [
                      Text(
                          "${_packageInfo.appName} is an app that'll help you keep up with what's going on in the world")
                    ]);
              }),
        ],
      ),
    );
  }

  Future<void> showChooseThemeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Choose theme"),
              contentPadding: EdgeInsets.fromLTRB(4.0, 20.0, 4.0, 4.0),
              actionsPadding: EdgeInsets.symmetric(horizontal: 24.0),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"),
                  autofocus: true,
                )
              ],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 0.0),
                  Consumer<AppThemeNotifier>(
                    builder: (context, themeState, _) => RadioListTile<String>(
                      title: Text("Dark"),
                      value: 'dark',
                      groupValue: _radioGroupValue,
                      onChanged: (value) {
                        // setState(() {
                        _radioGroupValue = value ?? 'dark';
                        // });
                        print('_selectedRadioValue $value');
                        themeState.setDarkMode();
                      },
                    ),
                  ),
                  Divider(height: 0.0),
                  Consumer<AppThemeNotifier>(
                    builder: (context, themeState, _) => RadioListTile<String>(
                      title: Text("Light"),
                      value: 'light',
                      groupValue: _radioGroupValue,
                      onChanged: (value) {
                        // setState(() {
                        _radioGroupValue = value ?? 'light';
                        // });
                        print('_selectedRadioValue $value');
                        themeState.setDarkMode();
                      },
                    ),
                  ),
                  Divider(height: 0.0),
                  Consumer<AppThemeNotifier>(
                    builder: (context, themeState, _) => RadioListTile<String>(
                      title: Text("Follow system"),
                      value: 'system',
                      groupValue: _radioGroupValue,
                      onChanged: (value) {
                        // setState(() {
                        _radioGroupValue = value ?? 'system';
                        // });
                        print('_selectedRadioValue $value');
                        MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? themeState.setDarkMode()
                            : themeState.setLightMode();
                      },
                    ),
                  ),
                  Divider(height: 0.0),
                ],
              ));
        });
  }
}
