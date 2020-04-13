import 'package:flutter/material.dart';
import 'package:sjovikvass_app/screens/landing/widgets/objects_list.dart';

//The screen that contains the list of object stored at the warehouse.
class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sjövik Vass & Entreprenad',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: ObjectsList(),
    );
  }
}
