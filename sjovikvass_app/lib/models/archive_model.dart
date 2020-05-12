import 'package:cloud_firestore/cloud_firestore.dart';

class Archive {
  final String id;
  final String season;
  final String ownerName;
  final String ownerId;
  final double billingSum;
  final String objectTitle;

  Archive(
      {this.id,
      this.season,
      this.ownerId,
      this.ownerName,
      this.billingSum,
      this.objectTitle});

  factory Archive.fromdoc(DocumentSnapshot doc) {
    return Archive(
        id: doc.documentID,
        season: doc['season'],
        ownerName: doc['ownerName'],
        ownerId: doc['ownerId'],
        billingSum: doc['billingSum'],
        objectTitle: doc['objectTitle']);
  }
}
