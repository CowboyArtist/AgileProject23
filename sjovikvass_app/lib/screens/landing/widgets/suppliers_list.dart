import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';
import 'package:sjovikvass_app/screens/supplierScreen/supplierScreen.dart';
import 'package:sjovikvass_app/services/database_service.dart';

class SuppliersList extends StatefulWidget {
  @override
  _SuppliersListState createState() => _SuppliersListState();
}

class _SuppliersListState extends State<SuppliersList> {
  Future<QuerySnapshot> _suppliers;

  @override
  void initState() {
    super.initState();
    _setupSuppliers();
  }

  //Used to fetch objects from database
  _setupSuppliers() async {
    Future<QuerySnapshot> suppliers = DatabaseService.getSuppliersFuture();
    setState(() {
      _suppliers = suppliers;
    });
  }

  _buildSuppliersTile(Supplier supplier) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SupplierScreen(
              //TODO

              ),
        ),
      ),
      child: Container(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          height: 100.0,
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(10.0)),
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: supplier.imageUrl == null
                        ? Image.asset(
                            'assets/images/placeholder_boat.jpg',
                            fit: BoxFit.cover,
                          )
                        : Image(
                            image:
                                CachedNetworkImageProvider(supplier.imageUrl),
                            fit: BoxFit.cover,
                          )),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              Positioned(
                  left: 16.0,
                  bottom: 16.0,
                  child: Text(
                    supplier.companyName,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: RefreshIndicator(
            //Pull down to refresh calls method _setupObjects
            onRefresh: () => _setupSuppliers(),
            child: FutureBuilder(
              future: _suppliers,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('Ingen data');
                }

                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      Supplier supplier =
                          Supplier.fromDoc(snapshot.data.documents[index]);
                      return _buildSuppliersTile(supplier);
                    });
              },
            ),
          ),
        )
      ],
    );
  }
}
