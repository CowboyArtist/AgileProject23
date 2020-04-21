import 'package:flutter/material.dart';
import 'package:sjovikvass_app/screens/boatImages/boatImages.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

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
        //visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BoatImages(),
    );
  }
}


