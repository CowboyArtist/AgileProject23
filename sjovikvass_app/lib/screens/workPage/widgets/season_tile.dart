import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/archive_model.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/archive_page_widget.dart';
import 'package:sjovikvass_app/services/database_service.dart';

//The list tile for the seasons
class SeasonTile extends StatelessWidget {
  final String season;
  final String inObjectId;
  SeasonTile({
    this.season,
    this.inObjectId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 3.0, offset: Offset(3, 3))
          ]),
      child: StreamBuilder(
        stream: DatabaseService.getArchiveForObject(inObjectId, season),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('Hämtar data'));
          }
          Archive archive = Archive.fromdoc(snapshot.data.documents[0]);
          return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArchivePage(
                            archive: archive,
                            inObjectId: inObjectId,
                            season: season,
                          )),
                );
              },
              title: Text(
                season,
                style: TextStyle(fontWeight: FontWeight.bold),
              ));
        },
      ),
    );
  }
}
