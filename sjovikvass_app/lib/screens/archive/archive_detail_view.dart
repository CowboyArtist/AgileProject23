import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/archive_model.dart';
import 'package:sjovikvass_app/models/work_order_material_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

class ArchiveDetailView extends StatelessWidget {
  final Archive archive;
  ArchiveDetailView({this.archive});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar(archive.objectTitle, context),
      body: StreamBuilder(
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
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: ExpansionTile(
                      initiallyExpanded: false,
                      title: Text(workOrder.title),
                      leading: Icon(Icons.expand_more),
                      trailing: Text(workOrder.sum.toInt().toString() + ' kr'),
                      children: <Widget>[
                        StreamBuilder(
                            stream: DatabaseService.getWorkOrderMaterials(
                                workOrder.id),
                            builder:
                                (BuildContext contect, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(child: Text('laddar'));
                              }
                              return ListView.builder(
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    WorkOrderMaterial workOrderMaterial =
                                        WorkOrderMaterial.fromDoc(
                                            snapshot.data.documents[index]);

                                    return Container(
                                        child: ListTile(
                                      leading: Text(workOrderMaterial.title),
                                      trailing: Text(workOrderMaterial.cost
                                          .toInt()
                                          .toString()),
                                    ));
                                  });
                            })
                      ],
                    ));
              });
        },
      ),
    );
  }
}
