import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geschehen/pages/home.dart';
import 'package:google_fonts/google_fonts.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({Key? key}) : super(key: key);

  static const String routeName = '/startup';

  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(milliseconds: 300),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "CHAD bytes",
              style: GoogleFonts.montserratSubrayada(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w600,
                fontSize: 32,
                textStyle: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Image.asset(
                'assets/images/logo.png',
                width: 300,
                height: 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
