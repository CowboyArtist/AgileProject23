import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:sjovikvass_app/styles/commonWidgets/myButton.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class BoatImages extends StatefulWidget {
  @override
  _BoatImagesState createState() => _BoatImagesState();
}

class _BoatImagesState extends State<BoatImages> {
  File _image;
  List<File> _images = [];

  List<Container> _buildImages() {
    return _images.map((_image) {
      var container = Container(
        child: Row(
          children: <Widget>[
            Center(
              child: Container(
                height: 350.0,
                width: 350.0,
                margin: EdgeInsets.all(30.0),
                child: Image.file(_image),
              ),
            ),
          ],
        ),
      );
      return container;
    }).toList();
  }

  _handleImage(ImageSource source) async {
    int index = 0;
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      setState(() {
        _image = imageFile;
        _images.insert(index, _image);
        index++;
      });
    }
  }

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
                onPressed: () {
                  _handleImage(ImageSource.gallery);
                },
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
              onPressed: () {
                _handleImage(ImageSource.camera);
              },
            ),
            SimpleDialogOption(
                child: Text('Från kamerarullen'),
                onPressed: () {
                  _handleImage(ImageSource.gallery);
                }),
            SimpleDialogOption(
              child: Text(
                'Avbryt',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar('Bilder'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  padding: EdgeInsets.all(10.0),
                  onPressed: () => _showSelectImageDialog(),
                ),
              ),
            ],
          ),
          Text(
            'Ny bild',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 11.0,
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView(
              children: _buildImages(),
            ),
          ),
        ],
      ),
    );
  }
}
