import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/storage_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

import 'package:image_picker/image_picker.dart';

import 'package:sjovikvass_app/models/boatImage_model.dart';

class BoatImages extends StatefulWidget {
  final String inObjectId;
  BoatImages({
    this.inObjectId,
  });

  @override
  _BoatImagesState createState() => _BoatImagesState();
}

class _BoatImagesState extends State<BoatImages> {
  File _image;
  

  _buildDarkerImage() {
    return GestureDetector(
      onTap: () => print('Metod för att kunna visa upp hela bilden'),
      child: Container(
        margin: EdgeInsets.all(10.0),
        height: 150.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  _buildTimeStamp(Timestamp timestamp) {
    return Positioned(
      child: Text(
        timestamp.toDate().toString(),
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

  _buildSingleImage(String imageUrl) {
    return Container(
      margin: EdgeInsets.all(10.0),
      height: 150.0,
      width: double.infinity,
      child: ClipRRect(
        child: imageUrl != null
            ? Image(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              )
            : Image.asset('assets/images/placeholder_boat.jpg',
                fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  _buildImageTile(BoatImageModel image) {
    return Stack(
      children: <Widget>[
        _buildSingleImage(image.imageUrl),
        _buildDarkerImage(),
        _buildTimeStamp(image.timestamp),
      ],
    );
  }

  _handleImage(ImageSource source) async {
    
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      String imageUrl = await StorageService.uploadObjectImage(imageFile);
      if (imageUrl != null) {
        BoatImageModel boatImageModel = BoatImageModel(
          imageUrl: imageUrl,
        );
        DatabaseService.uploadImage(boatImageModel, widget.inObjectId);
      }
      
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
      appBar: DetailAppBar.buildAppBar('Bilder', context),
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
          StreamBuilder(
            stream: DatabaseService.getObjectImages(widget.inObjectId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Text('Laddar in bilder');
              }
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      BoatImageModel image = BoatImageModel.fromDoc(
                          snapshot.data.documents[index]);
                      return _buildImageTile(image);
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
