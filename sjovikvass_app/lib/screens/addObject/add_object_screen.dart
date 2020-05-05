import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/screens/addObject/widgets/add_customer_widget.dart';
import 'package:sjovikvass_app/screens/addObject/widgets/add_object_widget.dart';
import 'package:sjovikvass_app/screens/addObject/widgets/add_supplier_widget.dart';

//Screen for adding objects to the database with corresponding attributes.
class AddObjectScreen extends StatefulWidget {
  
  final int initialPage;
  AddObjectScreen({this.initialPage});
  @override
  _AddObjectScreenState createState() => _AddObjectScreenState();
}

class _AddObjectScreenState extends State<AddObjectScreen> with SingleTickerProviderStateMixin{

   TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _controller.animateTo( widget.initialPage - 1);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lägg till'),
          bottom: TabBar(
            controller: _controller,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'Nytt Objekt',
              ),
              Tab(text: 'Ny kund',),
              Tab(
                text: 'Ny Leverantör',
              ),
              
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: TabBarView(
            controller: _controller,
            children: <Widget>[
              //Builds the view for creating new objects
              AddObjectWidget(tabController: _controller),

              AddCustomer(),
              //Builds the view for creating new supplier
              AddSupplierWidget(),

            ],
          ),
        ),
      ),
    );
  }
}
