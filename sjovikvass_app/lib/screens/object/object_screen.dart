import 'package:flutter/material.dart';

//The screen that shows the overview of one specific object.
class ObjectScreen extends StatefulWidget {
  @override
  _ObjectScreenState createState() => _ObjectScreenState();
}

class _ObjectScreenState extends State<ObjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Center(child: Text( 'Object Screen')),
    );
  }
}