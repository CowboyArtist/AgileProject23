import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/archive_model.dart';
import 'package:sjovikvass_app/models/work_order_material_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/email_service.dart';
import 'package:sjovikvass_app/services/phoneCall_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

class ArchiveDetailView extends StatelessWidget {
  final Archive archive;
  ArchiveDetailView({this.archive});

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
            return Text('hämtar kundnamn');
          }

          return Text(snapshot.data['name']);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar(archive.objectTitle, context),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Row(
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
                width: 20.0,
              ),
              _getCustomerName(),
              Spacer(),
              _buildActionButton(
                  Icons.phone,
                  () => PhoneCallService.showPhoneCallDialog(
                      context, '', '4432')),
              SizedBox(width: 10.0),
              _buildActionButton(Icons.mail,
                  () => EmailService.showEmailDialog(context, '', '')),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Row(
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
              SizedBox(width: 15.0),
              FutureBuilder(
                  future: DatabaseService.getCustomerById(archive.ownerId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('hämtar kundnamn');
                    }

                    return Text(snapshot.data['address'] +
                        ', ' +
                        snapshot.data['postalCode'] +
                        ' ' +
                        snapshot.data['city']);
                  }),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 15.0,
              ),
              Text(
                'Totalkostnad:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(archive.billingSum.truncateToDouble().toString() + ' kr'),
            ],
          ),
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
            height: 15.0,
          ),
          Expanded(
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
                      return Container(
                          color: Colors.black12,
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: ExpansionTile(
                            backgroundColor: Colors.lightBlue[50],
                            initiallyExpanded: false,
                            title: Text(
                              workOrder.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: Icon(Icons.expand_more),
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
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          WorkOrderMaterial workOrderMaterial =
                                              WorkOrderMaterial.fromDoc(snapshot
                                                  .data.documents[index]);

                                          return Container(
                                              child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Row(
                                              children: <Widget>[
                                                SizedBox(width: 20.0),
                                                Text(workOrderMaterial.title),
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
                          ));
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
