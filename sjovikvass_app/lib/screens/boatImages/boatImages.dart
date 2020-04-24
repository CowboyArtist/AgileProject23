import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

import 'package:image_picker/image_picker.dart';

class BoatImages extends StatefulWidget {
  @override
  _BoatImagesState createState() => _BoatImagesState();
}

class _BoatImagesState extends State<BoatImages> {
  File _image;
  List<File> _images = [];

  _buildDarkerImage() {
    return Container(
      margin: EdgeInsets.all(10.0),
      height: 150.0,
      width: 350.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black54],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  _buildTimeStamp() {
    return Positioned(
      child: Text(
        'Här har vi en fin timestamp',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
        ),
      ),
      bottom: 16.0,
      left: 16.0,
    );
  }

  _buildSingleImage() {
    return Container(
      margin: EdgeInsets.all(10.0),
      height: 150.0,
      width: 350.0,
      child: ClipRRect(
        child: Image.file(_image, fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  List<Container> _buildImages() {
    return _images.map((_image) {
      var container = Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                _buildSingleImage(),
                _buildDarkerImage(),
                _buildTimeStamp(),
              ],
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

  _buildNewImageBtn() {
    return ButtonTheme(
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
              _buildNewImageBtn(),
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
