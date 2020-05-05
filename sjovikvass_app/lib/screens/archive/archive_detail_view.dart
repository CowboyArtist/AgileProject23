import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/archive_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

class ArchiveDetailView extends StatelessWidget {
  Archive archive;
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
                    child: ListTile(
                        leading: Text(workOrder.title),
                        trailing:
                            Text(workOrder.sum.toInt().toString() + ' kr')));
              });
        },
      ),
    );
  }
}
