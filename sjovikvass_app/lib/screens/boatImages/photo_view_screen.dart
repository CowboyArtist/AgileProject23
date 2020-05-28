import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sjovikvass_app/models/boatImage_model.dart';
import 'package:sjovikvass_app/services/time_service.dart';

//Screen for viewing images in fullscreen 
class MyPhotoViewer extends StatelessWidget {
  final BoatImageModel image;
  MyPhotoViewer({
    this.image
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TimeService.getFormattedDateWithTime(image.timestamp.toDate())),),
      body: PhotoView(imageProvider: CachedNetworkImageProvider(image.imageUrl),)
    );
  }
}