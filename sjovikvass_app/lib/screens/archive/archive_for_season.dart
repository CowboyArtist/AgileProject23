import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sjovikvass_app/models/archive_model.dart';
import 'package:sjovikvass_app/models/customer_model.dart';
import 'package:sjovikvass_app/screens/archive/archive_detail_view.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

class ArchiveForSeason extends StatelessWidget {
  final String season;
  ArchiveForSeason({this.season});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DetailAppBar.buildAppBar(season, context),
        body: StreamBuilder(
          stream: DatabaseService.getArchiveForSeason(season),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('Laddar in arkiv...'));
            }
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Archive archive =
                      Archive.fromdoc(snapshot.data.documents[index]);

                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      Column(
                        children: <Widget>[
                          Checkbox(
                              value: archive.isBilled == null
                                  ? false
                                  : archive.isBilled,
                              onChanged: (value) =>
                                  DatabaseService.updateArchiveIsBilled(
                                      archive.id, season, value)),
                          Text('Fakturerad'),
                        ],
                      ),
                    ],
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      decoration: BoxDecoration(
                          color: archive.isBilled
                              ? Colors.lightGreen[200]
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5.0,
                                color: Colors.black12,
                                offset: Offset(3, 3))
                          ]),
                      child: ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ArchiveDetailView(
                                      archive: archive,
                                    ))),
                        title: Text(archive.objectTitle),
                        trailing:
                            Text(archive.billingSum.toInt().toString() + ' kr'),
                        subtitle: FutureBuilder(
                            future: DatabaseService.getCustomerById(
                                archive.ownerId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('hämtar kundnamn');
                              }
                              //Customer customer

                              return Text(snapshot.data['name']);
                            }),
                      ),
                    ),
                  );
                });
          },
        ));
  }
}
