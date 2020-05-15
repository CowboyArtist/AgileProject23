import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/archive_model.dart';

import 'package:sjovikvass_app/models/work_order_material_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/screens/archive/widgets/custom_expansiontile.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/utils/constants.dart';

//The page for the archives for one specific object
class ArchivePage extends StatefulWidget {
  final String season;
  final String inObjectId;
  final Archive archive;

  ArchivePage({this.season, this.inObjectId, this.archive});

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  double totalBillingSum = 0.0;

  //Calculates the total billing sum of all the archives during a season
  calculateTotalBillingSum() {
    archiveRef
        .document(widget.season)
        .collection('hasArchive')
        .where('objectId', isEqualTo: widget.inObjectId)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        setState(() {
          totalBillingSum += element['billingSum'];
        });
      });
    });
  }

//Builds the list view for the workorders that are archived.
  Expanded _buildWorkOrderListView() {
    return Expanded(
      child: StreamBuilder(
        stream: DatabaseService.getArchiveForObject(
            widget.inObjectId, widget.season),
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
        ) {
          if (!snapshot.hasData) {
            return Center(child: Text('Laddar in arkiv...'));
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              Archive insideArchive =
                  Archive.fromdoc(snapshot.data.documents[index]);

              return StreamBuilder(
                stream: DatabaseService.getWorkOrders(insideArchive.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('Laddar in arkiv...'));
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        WorkOrder workOrder =
                            WorkOrder.fromDoc(snapshot.data.documents[index]);

                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
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
                                trailing: Text(workOrder.sum
                                        .truncateToDouble()
                                        .toString() +
                                    ' kr'),
                                children: <Widget>[
                                  StreamBuilder(
                                      stream:
                                          DatabaseService.getWorkOrderMaterials(
                                              workOrder.id),
                                      builder: (BuildContext contect,
                                          AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(child: Text('Laddar'));
                                        }
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot.data.documents.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              WorkOrderMaterial
                                                  workOrderMaterial =
                                                  WorkOrderMaterial.fromDoc(
                                                      snapshot.data
                                                          .documents[index]);

                                              return Container(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8.0, 0.0, 0.0, 8.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    SizedBox(width: 20.0),
                                                    Container(
                                                        width: 90.0,
                                                        child: Text(
                                                            workOrderMaterial
                                                                .title)),
                                                    SizedBox(
                                                      width: 120.0,
                                                    ),
                                                    Text(workOrderMaterial
                                                        .amount
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
              );
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    calculateTotalBillingSum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar(widget.archive.objectTitle, context),
      body: Column(
        children: <Widget>[
          SizedBox(height: 15.0),

          Text(
            'Totalkostnad: ' + totalBillingSum.toString() + 'kr',
            style: TextStyle(fontSize: 20.0),
          ),

          SizedBox(
            height: 30.0,
          ),
          Align(
              alignment: Alignment.center,
              child: Text(
                'Utförda arbeten',
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
