import 'package:flutter/material.dart';

//The screen that contains the list of object stored at the warehouse.
class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Landing Screen'),
      ),
    );
  }
}