
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';
import 'package:sjovikvass_app/screens/supplierScreen/widgets/suppliers_list.dart';


//The screen for adding images to an object for determine the physical state of the object
class SupplierScreen extends StatefulWidget {
  final Supplier supplier;
  SupplierScreen({this.supplier});
  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          
            title: Text(
              'Leverantörer',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        body: SuppliersList()); //Scaffold
  }
}
