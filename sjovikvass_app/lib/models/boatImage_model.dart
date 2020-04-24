import 'package:cloud_firestore/cloud_firestore.dart';

class BoatImageModel {
  final String imageUrl;
  final Timestamp timestamp;
  final String comment;

  BoatImageModel({
    this.imageUrl,
    this.timestamp,
    this.comment,
  });

  factory BoatImageModel.fromDoc(DocumentSnapshot doc) {
    return BoatImageModel(
      imageUrl: doc['imageUrl'],
      timestamp: doc['timestamp'],
      comment: doc['comment'],
    );
  }
}
