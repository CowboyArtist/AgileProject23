import 'package:cloud_firestore/cloud_firestore.dart';

//A BoatImageModel different attributes
class BoatImageModel {
  final String imageUrl;
  final Timestamp timestamp;
  final String comment;

  BoatImageModel({
    this.imageUrl,
    this.timestamp,
    this.comment,
  });

//Method to create an BoatImageModel from database document
  factory BoatImageModel.fromDoc(DocumentSnapshot doc) {
    return BoatImageModel(
      imageUrl: doc['imageUrl'],
      timestamp: doc['timestamp'],
      comment: doc['comment'],
    );
  }
}
