import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/screens/addObject/widgets/add_object_widget.dart';
import 'package:sjovikvass_app/screens/addObject/widgets/add_supplier_widget.dart';

//Screen for adding objects to the database with corresponding attributes.
class AddObjectScreen extends StatefulWidget {
  @override
  _AddObjectScreenState createState() => _AddObjectScreenState();
}

class _AddObjectScreenState extends State<AddObjectScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lägg till'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'Nytt Objekt',
              ),
              Tab(
                text: 'Ny Leverantör',
              ),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: TabBarView(
            children: <Widget>[
              //Builds the view for creating new objects
              AddObjectWidget(),
              //Builds the view for creating new supplier
              AddSupplierWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
