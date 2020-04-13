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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(children: <Widget>[
          LandingScreen(),
          Center(child: Text('Leverantörer')),
          Center(child: Text('Statistik')),
        ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddObjectScreen()),
              );
            }),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 40.0),
          child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.black87,
              tabs: [
                Tab(
                  icon: Icon(Icons.filter_list),
                ),
                Tab(
                  icon: Icon(Icons.shop),
                ),
                Tab(
                  icon: Icon(Icons.multiline_chart),
                )
              ]),
        ),
      ),
    );
  }
}
