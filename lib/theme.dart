import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeNotifier with ChangeNotifier {
  ThemeData _themeData =
      WidgetsBinding.instance?.platformDispatcher.platformBrightness ==
              Brightness.dark
          ? AppTheme.darkTheme
          : AppTheme.lightTheme;

  AppThemeNotifier.init(this._themeData);

  AppThemeNotifier(BuildContext? context) {
    SharedPreferences.getInstance().then((prefs) {
      var isDark = prefs.getBool('darkMode') ??
          WidgetsBinding.instance?.platformDispatcher.platformBrightness ==
              Brightness.dark;

      print('value read from prefs: ' + isDark.toString());
      if (isDark) {
        print('setting dark theme');
        _themeData = AppTheme.darkTheme;
      } else {
        _themeData = AppTheme.lightTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = AppTheme.darkTheme;
    setThemeMode(true);
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = AppTheme.lightTheme;
    setThemeMode(false);
    notifyListeners();
  }

  ThemeData getTheme() => _themeData;

  bool isDarkTheme() => _themeData.brightness == Brightness.dark;

  Future setThemeMode(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }
}

class AppTheme {
  static final _lightTextTheme = ThemeData.light().textTheme;
  static final _blackTextTheme = ThemeData.dark().textTheme;

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFFFAFAFA), // Colors.white,
    primaryColor: Colors.white,
    accentColor: Colors.redAccent,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.grey[50]),
      iconTheme: IconThemeData(
        color: Colors.black.withOpacity(0.67),
      ),
      titleTextStyle: GoogleFonts.libreFranklin(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.black87,
      ),
    ),
    sliderTheme: SliderThemeData().copyWith(
      trackHeight: 2.0,
      inactiveTrackColor: Color(0x1F000000),
      activeTrackColor:  Colors.redAccent,
      trackShape: CustomTrackShape(),
      thumbColor: Colors.redAccent,
      thumbShape: SliderComponentShape.noThumb,
      // thumbShape: RoundSliderThumbShape(
      //     enabledThumbRadius: 1.0, disabledThumbRadius: 0.0),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[50],
      unselectedItemColor: Colors.black54,
      selectedItemColor: Colors.redAccent,
      // showUnselectedLabels: false,
      // showSelectedLabels: false,
    ),
    dividerColor: Color(0x1F000000),
    iconTheme: IconThemeData(color: Colors.black54),
    highlightColor: Colors.transparent,
    textTheme: TextTheme(
      // bodyText2: GoogleFonts.montserrat(
      //   // fontWeight: FontWeight.w300,
      //   fontSize: 16,
      //   textStyle: _lightTextTheme.bodyText2,
      // ),
      bodyText2: _lightTextTheme.bodyText2?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        fontFamily: "Luman-Serif",
      ),
      bodyText1: GoogleFonts.montserrat(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        // color: Colors.black.withOpacity(0.5),
        textStyle: _lightTextTheme.bodyText1,
      ),
      // headline4: GoogleFonts.montserrat(
      //   fontWeight: FontWeight.w500,
      //   fontSize: 18,
      //   color: Colors.black,
      //   textStyle: _lightTextTheme.headline4,
      // ),
      headline4: TextStyle(
        fontFamily: "Lumin-Serif",
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontSize: 20,
      ),
      headline5: GoogleFonts.libreFranklin(
        // fontWeight: FontWeight.w500,
        // fontSize: 16,
        textStyle: _lightTextTheme.headline5,
      ),
      subtitle1: GoogleFonts.montserrat(
        // fontWeight: FontWeight.w500,
        // fontSize: 16,
        textStyle: _lightTextTheme.subtitle1,
      ),
      subtitle2: GoogleFonts.montserrat(
        color: Colors.black.withOpacity(0.5),
        // fontWeight: FontWeight.w400,
        // fontSize: 14,
        textStyle: _lightTextTheme.subtitle2,
      ),
      headline6: GoogleFonts.libreFranklin(
        textStyle: _lightTextTheme.headline6,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade800,
    // primaryColor: Colors.grey,
    // brightness: Brightness.dark,
    accentColor: Colors.redAccent.shade200,
    toggleableActiveColor: Colors.blue.shade200,
    colorScheme: ColorScheme.dark(
        // primary: Colors.grey.shade800,
        // primaryVariant: Colors.grey.shade800,
        primary: Colors.blue.shade200,
        primaryVariant: Colors.blue.shade400,
        onPrimary: Colors.white,
        secondary: Colors.white,
        secondaryVariant: Colors.grey.shade100,
        onSecondary: Colors.grey.shade800),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade800,
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Color(0xFF383838),
      ),
      titleTextStyle: GoogleFonts.libreFranklin(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white70),
    ),
    sliderTheme: SliderThemeData().copyWith(
        trackHeight: 2.0,
        inactiveTrackColor: Color(0xFF393939),
        activeTrackColor:Colors.redAccent.shade200,
        trackShape: CustomTrackShape(),
        // disabledThumbColor: Colors.transparent,
        thumbColor: Colors.redAccent.shade200,
        thumbShape: SliderComponentShape.noThumb
        // thumbShape: RoundSliderThumbShape(
        //     enabledThumbRadius: 1.0, disabledThumbRadius: 0.0),
        ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF393939), //Colors.grey.shade800,
      // showUnselectedLabels: false,
      // showSelectedLabels: false,
      // unselectedItemColor: Colors.white54,
      // selectedItemColor: Colors.redAccent.shade200,
    ),
    // cardTheme: CardTheme(color: Colors.grey[800]),
    iconTheme: IconThemeData(color: Colors.white54),

    textTheme: TextTheme(
      // bodyText2: GoogleFonts.montserrat(
      //   fontWeight: FontWeight.w300,
      //   fontSize: 14,
      //   textStyle: _blackTextTheme.bodyText2,
      // ),
      bodyText2: _lightTextTheme.bodyText2?.copyWith(
        color: Colors.white70,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        fontFamily: "Luman-Serif",
      ),
      bodyText1: GoogleFonts.montserrat(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        textStyle: _blackTextTheme.bodyText1,
      ),
      // headline4: GoogleFonts.montserrat(
      //   color: Colors.white,
      //   fontWeight: FontWeight.w500,
      //   fontSize: 18,
      //   textStyle: _blackTextTheme.headline4,
      // ),
      headline4: TextStyle(
        fontFamily: "Lumin-Serif",
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontSize: 20,
      ),
      headline5: GoogleFonts.libreFranklin(
        textStyle: _blackTextTheme.headline5,
      ),
      subtitle1: GoogleFonts.montserrat(
        color: Colors.white70,
        textStyle: _blackTextTheme.subtitle1,
      ),
      subtitle2: GoogleFonts.montserrat(
        color: Colors.white70,
        textStyle: _blackTextTheme.subtitle2,
      ),
      headline6: GoogleFonts.libreFranklin(
        textStyle: _blackTextTheme.headline6,
      ),
    ),
  );
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
