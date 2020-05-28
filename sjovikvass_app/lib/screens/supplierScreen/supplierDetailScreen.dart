import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/contact_model.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/commonWidgets/my_placeholder.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
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
          widget.supplier.description.isEmpty ? SizedBox.shrink() : Column(
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
              SizedBox(height: 15.0),
              Divider()
            ],
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
              Spacer(),
              RaisedButton.icon(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddContact(
                            inSupplierId: widget.supplier.id,
                          ),
                        ),
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
          SizedBox(height: 10.0),
          Expanded(
            child:
                //Stream that updates the UI when values in database changes.
                StreamBuilder(
                    stream: DatabaseService.getContacts(widget.supplier.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Hämtar data');
                      }
                      if (snapshot.data.documents.length == 0) {
                return Center(child: MyPlaceholder(icon: Icons.people, title: 'Inga kontaktpersoner', subtitle: 'Lägg till nya kontaktpesoner med knappen ovan.',));
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
