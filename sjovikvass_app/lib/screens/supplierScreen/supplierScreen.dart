import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';
import 'package:sjovikvass_app/screens/landing/widgets/suppliers_list.dart';

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
            title: Text(
              'Leverantörer',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white),
        body: SuppliersList()); //Scaffold
  }
}
