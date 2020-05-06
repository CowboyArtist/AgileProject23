import 'package:flutter/material.dart';
import 'package:sjovikvass_app/screens/addObject/add_object_screen.dart';
import 'package:sjovikvass_app/screens/landing/landing_screen.dart';
import 'package:sjovikvass_app/screens/supplierscreen/supplierScreen.dart';

//Used to handle navigation
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: <Widget>[
          LandingScreen(),
          SupplierScreen(),
          Center(child: Text('Statistik')),
        ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddObjectScreen(initialPage: _controller.index == 1 ? 3 : 1,)),
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
              ],
              controller: _controller,),
        ),
      ),
    );
  }
}
