import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sjovikvass_app/screens/boatImages/photo_view_screen.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/handle_image_service.dart';
import 'package:sjovikvass_app/services/storage_service.dart';
import 'package:sjovikvass_app/services/time_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

import 'package:image_picker/image_picker.dart';

import 'package:sjovikvass_app/models/boatImage_model.dart';

//The screen for adding images to an object for determine the physical state of the object
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

  //Adds black gradient overlay to make the white text stand out
  _buildOverlay() {
    return Container(
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
    );
  }

  //Shows the date and time the image was added
  _buildTimeStamp(Timestamp timestamp) {
    return Positioned(
      child: Text(
        TimeService.getFormattedDateWithTime(timestamp.toDate()),
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

  //Fetch image from database and displays in widget
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

  _showDeleteAlertDialog(BuildContext context, BoatImageModel image) {
    Widget okButton = FlatButton(
      color: Colors.redAccent,
      child: Text("Radera"),
      onPressed: () {
        DatabaseService.removeOneImage(widget.inObjectId, image.id);

        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Avbryt"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Vill du ta bort bilden?"),
      content: Text("Detta kan inte ångras i efterhand."),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //The core of the list tile that shows the image
  _buildImageTile(BoatImageModel image) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MyPhotoViewer(
            image: image,
          ),
        ),
      ),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
              color: Colors.transparent,
              foregroundColor: Colors.red,
              caption: 'Radera',
              icon: Icons.delete,
              onTap: () => _showDeleteAlertDialog(context, image)),
        ],
        child: Stack(
          children: <Widget>[
            _buildSingleImage(image.imageUrl),
            _buildOverlay(),
            _buildTimeStamp(image.timestamp),
          ],
        ),
      ),
    );
  }

  //Fetch the file from device and adds it to database
  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      String imageUrl = await StorageService.uploadObjectImage(imageFile);
      if (imageUrl != null) {
        //Create BoatImageModel to be able to link imageUrl with the timestamp of the upload.
        BoatImageModel boatImageModel = BoatImageModel(
          imageUrl: imageUrl,
        );
        DatabaseService.uploadImage(boatImageModel, widget.inObjectId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar('Bilder', context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30.0),

          //Fetch the stream of new images added to the database and displays it in the app UI
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
                      //Translates database documents to a BoatImageModel object.
                      BoatImageModel image = BoatImageModel.fromDoc(
                          snapshot.data.documents[index]);
                      return _buildImageTile(image);
                    }),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () => ImageService.showSelectImageDialog(context, _handleImage),
        child: Container(
            margin: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 40.0),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: MyColors.primary,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3, 3),
                      blurRadius: 5.0)
                ],
                borderRadius: BorderRadius.circular(10.0)),
            child: Center(
                child: Text(
              'Ny bild',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }
}
