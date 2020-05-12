import 'package:flutter/material.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/commonWidgets/season_tile.dart';

class ArchivePage extends StatefulWidget {
  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  List<SeasonTile> seasonTiles = [SeasonTile(), SeasonTile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DetailAppBar.buildAppBar('Arkiv', context),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: seasonTiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SeasonTile();
                  }),
            ),
          ],
        ));
  }
}
