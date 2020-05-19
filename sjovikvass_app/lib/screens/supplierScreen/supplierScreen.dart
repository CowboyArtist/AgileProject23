
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                  '   Leverantörer',
                  style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
            Expanded(child: SuppliersList()),
          ],
        )); //Scaffold
  }
}
