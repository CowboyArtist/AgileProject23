import 'package:flutter/material.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/commonWidgets/season_tile.dart';

class ArchivePage extends StatefulWidget {
  final String objectId;

  ArchivePage({
    this.objectId,
  });

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  Future<List<String>> seasons;

  @override
  void initState() {
    super.initState();
    _setupSeasons();
  }

  _setupSeasons() async {
    Future<List<String>> _seasons =
        DatabaseService.getSeasonsForObjectArchive(widget.objectId);
    setState(() {
      seasons = _seasons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DetailAppBar.buildAppBar('Arkiv', context),
        body: Column(
          children: <Widget>[
            Expanded(
                /*
              child: FutureBuilder(
                  future: DatabaseService.getSeasonsForObjectArchive(
                      widget.objectId),
                  builder: (context, snapshot) {
                    
                    print(snapshot.data.length);
                    */
                child: FutureBuilder(
                    future: DatabaseService.getSeasonsForObjectArchive(
                        widget.objectId),
                    builder: (context, snapshot) {
                      print(snapshot.toString());
                      if (!snapshot.hasData) {
                        return Center(child: Text('Har inte data'));
                      }
                      if (snapshot.data.length == 0) {
                        return Center(child: Text('Inga arkivobjekt'));
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            // print(seasons.length);
                            return SeasonTile(
                              season: snapshot.data[index],
                            );
                          });
                    })),
          ],
        ));
  }
}
