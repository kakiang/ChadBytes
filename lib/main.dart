import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'service/article_service.dart';
import 'pages/home.dart';
import 'service/download_notifier.dart';
import 'package:provider/provider.dart';
import 'model/database.dart';
import 'service/prefs_notifier.dart';
import 'pages/startup_screen.dart';

import 'theme.dart';

Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.data.isNotEmpty) {
    Map<String, dynamic> data = message.data;
    notificationsPlugin.show(
        message.hashCode,
        data["title"],
        data["body"],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
          ),
        ));
    // ArticleService articleService = ArticleService(db: AppDb());
    // await compute(articleService.fetchFromNetwork);
  }

  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await notificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    // selectedNotificationPayload = notificationAppLaunchDetails!.payload;

  }

  FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
  await notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp(notificationAppLaunchDetails));
}

class MyApp extends StatefulWidget {
    MyApp(this.notificationAppLaunchDetails, {Key? key}) : super(key: key);
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void handleNotificationMessage(
      FlutterLocalNotificationsPlugin notificationsPlugin,
      RemoteMessage message) {
    if (message.data.isNotEmpty) {
      Map<String, dynamic> data = message.data;
//     AndroidNotification android = message.notification.android!;
      notificationsPlugin.show(
          message.hashCode,
          data["title"],
          data["body"],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
            ),
          ));
    }
  }

  initFirebaseMessaging() async {
    await FirebaseMessaging.instance.subscribeToTopic('newsUpdate');

    var initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from a terminated state! ${initialMessage.messageId}');
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Also handle any interaction when the app is in the background via a Stream listener');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleNotificationMessage(notificationsPlugin, message);
    });
  }

  @override
  void initState() {
    super.initState();

    var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    var init = InitializationSettings(android: androidInit);

    notificationsPlugin.initialize(init);
    initFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: widget.notificationAppLaunchDetails),
        Provider<AppDb>(create: (context) => AppDb()),
        ProxyProvider<AppDb, ArticleService>(
            update: (context, db, _) => ArticleService(db: db)),
        ChangeNotifierProvider<AppThemeNotifier>(
            create: (context) => AppThemeNotifier(context)),
        ChangeNotifierProvider<PrefsNotifier>(
            create: (context) => PrefsNotifier()),
        ChangeNotifierProvider<DownloadNotifier>(
            create: (context) => DownloadNotifier())
      ],
      child: Consumer<AppThemeNotifier>(
        builder: (context, themeState, _) => MaterialApp(
          title: 'CHAD Bytes',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              themeState.isDarkTheme() ? ThemeMode.dark : ThemeMode.light,
          home: StartupScreen(),
        ),
      ),
    );
  }
}
