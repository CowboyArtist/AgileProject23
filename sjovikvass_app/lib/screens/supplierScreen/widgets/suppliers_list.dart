import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sjovikvass_app/models/contact_model.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/email_service.dart';
import 'package:sjovikvass_app/services/phoneCall_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/my_button.dart';
import 'package:sjovikvass_app/styles/commonWidgets/my_placeholder.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

import '../supplierDetailScreen.dart';

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

  _showDeleteAlertDialog(BuildContext context, Supplier supplier) {
    Widget okButton = FlatButton(
      color: Colors.redAccent,
      child: Text("Radera"),
      onPressed: () {
        DatabaseService.removeSupplier(supplier.id);
        _setupSuppliers();
        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Avbryt"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Vill du ta bort ${supplier.companyName}?"),
      content: Text("Detta kan inte ångras i efterhand."),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _buildSuppliersTile(Supplier supplier) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SupplierDetailScreen(supplier: supplier),
          ),
        );
      },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
              color: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Colors.red,
              caption: 'Radera',
              icon: Icons.delete,
              onTap: () => _showDeleteAlertDialog(context, supplier)),
        ],
        child: Container(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          height: 140.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0, // has the effect of softening the shadow
                spreadRadius: 2.0, // has the effect of extending the shadow
                offset: Offset(
                  3.0, // horizontal, move right 10
                  3.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: FutureBuilder(
            future: DatabaseService.getContactById(
                supplier.mainContact, supplier.id),
            builder: (context, snapshot) {
              ContactModel contact;
              if (snapshot.data != null) {
                contact = ContactModel.fromDoc(snapshot.data);
              }
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
                        width: 300.0,
                        child: Text(
                          supplier.companyName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      MyLightBlueButton(
                          icon: Icons.phone,
                          label: 'Ring',
                          onTap: () => PhoneCallService.showPhoneCallDialog(
                              context,
                              contact != null
                                  ? supplier.companyName +
                                      "'s kontaktperson " +
                                      contact.name
                                  : _showErrorMessage(),
                              contact.phoneNumber)),
                      SizedBox(width: 20),
                      MyLightBlueButton(
                        icon: Icons.mail,
                        label: 'Maila',
                        onTap: () => EmailService.showEmailDialog(
                          context,
                          contact != null
                              ? supplier.companyName +
                                  "'s kontaktperson " +
                                  contact.name
                              : _showErrorMessage(),
                          contact.email,
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                          padding: EdgeInsets.all(5),
                          height: 70,
                          width: 220,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                supplier.description,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15),
                                maxLines: 3,
                              ),
                            ],
                          ))
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
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
                  return Center(
                      child: Container(
                    height: 80.0,
                    width: 80.0,
                    child: CircularProgressIndicator(),
                  ));
                }
                if (snapshot.data.documents.length == 0) {
                  return Center(
                      child: MyPlaceholder(
                    title: 'Inga leverantörer',
                    subtitle: 'Klicka på "+" för att lägga till ny leverantör.',
                    assetPath: 'assets/images/missing_lev.png',
                  ));
                }

                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Supplier supplier =
                        Supplier.fromDoc(snapshot.data.documents[index]);
                    return _buildSuppliersTile(supplier);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  _showErrorMessage() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Något gick snett :-("),
          content: new Text("Du måste ange en huvudkontakt till leverantören!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Stäng"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
