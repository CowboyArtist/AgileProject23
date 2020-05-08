import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/contact_model.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/phoneCall_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:sjovikvass_app/services/email_service.dart';
import 'package:sjovikvass_app/screens/addContact/add_contact.dart';
import 'package:sjovikvass_app/screens/addContact/contact_tile.dart';

class SupplierDetailScreen extends StatefulWidget {
  final Supplier supplier;

  SupplierDetailScreen({this.supplier});

  @override
  _SupplierDetailScreenState createState() => _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar(widget.supplier.companyName, context),
      body: Column(
        children: <Widget>[
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300.0,
                child: Text(
                  widget.supplier.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ButtonTheme(
                minWidth: 30.0,
                height: 30.0,
                child: RaisedButton(
                  color: MyColors.lightBlue,
                  child: Icon(
                    Icons.phone,
                    color: MyColors.primary,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  padding: EdgeInsets.all(10.0),
                  onPressed: () => PhoneCallService.showPhoneCallDialog(context,
                      widget.supplier.companyName, widget.supplier.phoneNr),
                ),
              ),
              ButtonTheme(
                minWidth: 30.0,
                height: 30.0,
                child: RaisedButton(
                  color: MyColors.lightBlue,
                  child: Icon(
                    Icons.mail,
                    color: MyColors.primary,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  padding: EdgeInsets.all(10.0),
                  onPressed: () => EmailService.showEmailDialog(context,
                      widget.supplier.companyName, widget.supplier.email),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 115.0,
              ),
              Text('Ring',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  )),
              SizedBox(
                width: 122.0,
              ),
              Text('Maila',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey))
            ],
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 2.0,
              width: double.infinity,
              color: Colors.grey[200],
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                '   Kontaktpersoner',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
              //SizedBox(width: 100.0),
              Spacer(),

              RaisedButton.icon(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AddContact(
                                  inSupplierId: widget.supplier.id,
                                )),
                      ),
                  icon: Icon(
                    Icons.add,
                    color: MyColors.primary,
                  ),
                  label: Text(
                    'Ny Kontakt',
                    style: TextStyle(color: MyColors.primary),
                  ),
                  color: MyColors.lightBlue),
              SizedBox(width: 18),
            ],
          ),
          Expanded(
            child:
                //Stream that updates the UI when values in database changes.
                StreamBuilder(
                    stream: DatabaseService.getContacts(widget.supplier.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Hämtar data');
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          ContactModel contactModel = ContactModel.fromDoc(
                              snapshot.data.documents[index]);

                          return ContactTile(
                            inSupplierId: widget.supplier.id,
                            contact: contactModel,
                            supplierMainContact: widget.supplier.mainContact,
                          );
                        },
                      );
                    }),
          ),
        ],
      ),
    );
  }
}
