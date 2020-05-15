import 'package:flutter/material.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/season_tile.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

import 'package:sjovikvass_app/utils/constants.dart';

class SeasonPage extends StatefulWidget {
  final String objectId;

  SeasonPage({
    this.objectId,
  });

  @override
  _SeasonPageState createState() => _SeasonPageState();
}

class _SeasonPageState extends State<SeasonPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DetailAppBar.buildAppBar('Säsonger', context),
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
                                    ? SeasonTile(
                                        inObjectId: widget.objectId,
                                        season: snapshot.data.documents[index]
                                            ['season'],
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
