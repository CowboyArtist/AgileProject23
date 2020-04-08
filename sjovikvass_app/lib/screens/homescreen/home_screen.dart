import 'package:flutter/material.dart';
import 'package:sjovikvass_app/screens/addObject/add_object_screen.dart';
import 'package:sjovikvass_app/screens/landing/landing_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sjövik Vass App')),
      body: LandingScreen(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddObjectScreen()),
        );
      }),
    );
  }
}
