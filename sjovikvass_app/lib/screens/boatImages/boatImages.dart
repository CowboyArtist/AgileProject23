import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:sjovikvass_app/styles/commonWidgets/myButton.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

class BoatImages extends StatefulWidget {
  @override
  _BoatImagesState createState() => _BoatImagesState();
}

class _BoatImagesState extends State<BoatImages> {
  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Lägg till foto'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Ta ett foto'),
                onPressed: () => print('Kör metod för att ta foto'),
              ),
              CupertinoActionSheetAction(
                child: Text('Från galleriet'),
                onPressed: () =>
                    print('Kör metod för att välja från kamerarullen'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('Avbryt'),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Lägg till foto'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Ta ett foto'),
              onPressed: () => print('Kör metod för att ta foto'),
            ),
            SimpleDialogOption(
              child: Text('Från kamerarullen'),
              onPressed: () =>
                  print('Kör metod för att välja från kamerarullen'),
            ),
            SimpleDialogOption(
              child: Text(
                'Avbryt',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar('Bilder'),
      body: Container(
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    ButtonTheme(
                      minWidth: 30.0,
                      height: 30.0,
                      child: RaisedButton(
                        color: MyColors.lightBlue,
                        child: Icon(
                          Icons.add_a_photo,
                          color: MyColors.primary,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        padding: EdgeInsets.all(10.0),
                        onPressed: () => _showSelectImageDialog(),
                      ),
                    ),
                    Text(
                      'Ny bild',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
