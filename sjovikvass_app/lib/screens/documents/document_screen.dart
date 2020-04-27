import 'package:flutter/material.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

class DocumentScreen extends StatefulWidget {
  final String inObjectId;
  DocumentScreen({this.inObjectId});
  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar('Dokument', context),
      body: Column(
        children: <Widget>[
          Container(
            height: 140.0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      color: MyColors.lightBlue,
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: IconButton(
                      icon: Icon(Icons.scanner),
                      onPressed: () => print('Open Scanner'),
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Text('Scanna ny')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
