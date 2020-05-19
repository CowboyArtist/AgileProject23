import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/archive_model.dart';
import 'package:sjovikvass_app/models/customer_model.dart';
import 'package:sjovikvass_app/models/work_order_material_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/screens/archive/widgets/custom_expansiontile.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/email_service.dart';
import 'package:sjovikvass_app/services/phoneCall_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

class ArchiveDetailView extends StatelessWidget {
  final Archive archive;
  ArchiveDetailView({this.archive});

//builds phone and email button
  Widget _buildActionButton(IconData icon, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: MyColors.primary, borderRadius: BorderRadius.circular(5.0)),
        child: Icon(
          icon,
          size: 15.0,
          color: Colors.white,
        ),
      ),
    );
  }

  FutureBuilder _getCustomerName() {
    return FutureBuilder(
        future: DatabaseService.getCustomerById(archive.ownerId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Ingen tilldelad ägare');
          } else if (!snapshot.data.exists) {
            return Text('Kunden är borttagen från systemet');
          } else {
            return Text(snapshot.data['name']);
          }
        });
  }

  FutureBuilder _buildNameCallAndMailButtonsRow() {
    //Gets the customer from the Database
    return FutureBuilder(
        future: DatabaseService.getCustomerById(archive.ownerId),
        builder: (context, snapshot) {
          Customer customer;
          String name;
          if (!snapshot.hasData) {
            //chillax bro
            Text('sdfds');
          } else if (!snapshot.data.exists) {
            name = 'Kunden är borttagen från systemet';
          } else {
            customer = Customer.fromDoc(snapshot.data);
            name = customer.name;
          }

          return Row(
            children: <Widget>[
              SizedBox(
                width: 15.0,
              ),
              Text(
                'Kund:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              _getCustomerName(),
              Spacer(),
              (snapshot.hasData && snapshot.data.exists)
                  ? _buildActionButton(
                      Icons.phone,
                      () => PhoneCallService.showPhoneCallDialog(
                          context, name, customer.phone))
                  : Container(),
              SizedBox(width: 10.0),
              (snapshot.hasData && snapshot.data.exists)
                  ? _buildActionButton(
                      Icons.mail,
                      () => EmailService.showEmailDialog(
                          context, name, customer.email))
                  : Container(),
              SizedBox(
                width: 10.0,
              ),
            ],
          );
        });
  }

  Row _buildAddressRow() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 15.0,
        ),
        Text(
          'Adress:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        SizedBox(width: 10.0),
        FutureBuilder(
            future: DatabaseService.getCustomerById(archive.ownerId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Ingen tilldelad ägare');
              } else if (!snapshot.data.exists) {
                return Text('Kunden är borttagen från systemet');
              } else {
                return Text(snapshot.data['address'] +
                    ', ' +
                    snapshot.data['postalCode'] +
                    ' ' +
                    snapshot.data['city']);
              }
            }),
      ],
    );
  }

  Row _buildTotalPriceRow() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 15.0,
        ),
        Text(
          'Total kostnad:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(archive.billingSum.truncateToDouble().toString() + ' kr'),
      ],
    );
  }

  Expanded _buildWorkOrderListView() {
    return Expanded(
      child: StreamBuilder(
        stream: DatabaseService.getWorkOrders(archive.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('Laddar in arkiv...'));
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                WorkOrder workOrder =
                    WorkOrder.fromDoc(snapshot.data.documents[index]);
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black12,
                      ),
                      margin: EdgeInsets.only(bottom: 8.0),

                      //customized ExpansionTile to make arrow icon leading.
                      child: MyExpansionTile(
                        backgroundColor: Colors.lightBlue[50],
                        initiallyExpanded: false,
                        title: Text(
                          workOrder.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                            workOrder.sum.truncateToDouble().toString() +
                                ' kr'),
                        children: <Widget>[
                          StreamBuilder(
                              stream: DatabaseService.getWorkOrderMaterials(
                                  workOrder.id),
                              builder: (BuildContext contect,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: Text('laddar'));
                                }
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      WorkOrderMaterial workOrderMaterial =
                                          WorkOrderMaterial.fromDoc(
                                              snapshot.data.documents[index]);

                                      return Container(
                                          child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 0.0, 0.0, 8.0),
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(width: 20.0),
                                            Container(
                                                width: 90.0,
                                                child: Text(
                                                    workOrderMaterial.title)),
                                            SizedBox(
                                              width: 120.0,
                                            ),
                                            Text(workOrderMaterial.amount
                                                .toStringAsFixed(1)),
                                            Spacer(),
                                            Text(workOrderMaterial.cost
                                                    .truncateToDouble()
                                                    .toString() +
                                                ' kr'),
                                            SizedBox(width: 15.0),
                                          ],
                                        ),
                                      ));
                                    });
                              })
                        ],
                      )),
                );
              });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar(archive.objectTitle, context),
      body: Column(
        children: <Widget>[
          SizedBox(height: 15.0),

          _buildNameCallAndMailButtonsRow(),

          SizedBox(height: 15.0),

          //Text for address
          _buildAddressRow(),

          SizedBox(height: 15.0),

          _buildTotalPriceRow(),
          SizedBox(
            height: 30.0,
          ),
          Align(
              alignment: Alignment.center,
              child: Text(
                'Utförda Arbeten',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Divider(
              color: Colors.black,
              thickness: 1.0,
            ),
          ),
          //builds the listview with workorders with related materials
          _buildWorkOrderListView()
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 30.0,
      ),
    );
  }
}
