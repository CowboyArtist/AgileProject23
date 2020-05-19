import 'package:flutter/material.dart';
import 'package:sjovikvass_app/screens/archive/archive_for_season.dart';
import 'package:sjovikvass_app/styles/commonWidgets/my_placeholder.dart';
import 'package:sjovikvass_app/utils/constants.dart';

class ArchiveSeasonsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Text(
              '     Arkivet',
              style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: seasonsRef.orderBy('timestamp').snapshots(),
                  builder: (BuildContext context, snapshot) {
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
                        child: MyPlaceholder(title: 'Inga arkiverade objekt', subtitle: 'När du klickat i "Arkivera" för någon arbetsorder hittar du dem här.',),
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 3.0,
                                      offset: Offset(3, 3))
                                ]),
                            child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ArchiveForSeason(
                                              season: snapshot.data
                                                  .documents[index]['season'],
                                            )),
                                  );
                                },
                                title: Text(
                                  snapshot.data.documents[index]['season'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          );
                        });
                  }),
            )
          ])),
    );
  }
}
