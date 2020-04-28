import 'package:cloud_firestore/cloud_firestore.dart';

//A DocumentModel different attributes
class DocumentModel {
  final String id;
  final String fileUrl;
  final Timestamp timestamp;
  final String comment;

  DocumentModel({
    this.id,
    this.fileUrl,
    this.timestamp,
    this.comment,
  });

//Method to create an DocumentModel from database document
  factory DocumentModel.fromDoc(DocumentSnapshot doc) {

    return DocumentModel(
      id: doc.documentID,
      fileUrl: doc['fileUrl'],
      timestamp: doc['timestamp'],
      comment: doc['comment'],
    );
  }
}