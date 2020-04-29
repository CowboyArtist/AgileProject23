import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/screens/homescreen/home_screen.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyColors.primary,
      ),
      home: HomeScreen(),
    );
  }
}
