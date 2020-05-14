import 'package:flutter/material.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/commonWidgets/season_tile.dart';
import 'package:sjovikvass_app/utils/constants.dart';

class ArchivePage extends StatefulWidget {
  final String objectId;

  ArchivePage({
    this.objectId,
  });

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
 

  @override
  void initState() {
    super.initState();
    
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DetailAppBar.buildAppBar('Arkiv', context),
        body: Column(
          children: <Widget>[
            FutureBuilder(
                future: seasonsRef.orderBy('timestamp').getDocuments(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                      child: Text('Inget arkiv ännu...'),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FutureBuilder(
                              future: DatabaseService.objectHasArchiveForSeason(
                                  snapshot.data.documents[index]['season'],
                                  widget.objectId),
                              builder: (context, snap) {
                                if (!snap.hasData) {
                                  return SizedBox.shrink();
                                }
                                return snap.data
                                    ? ListTile(
                                        title: Text(snapshot
                                            .data.documents[index]['season']),
                                      )
                                    : SizedBox.shrink();
                              });
                        }),
                  );
                })
      
          ],
        ));
  }
}
