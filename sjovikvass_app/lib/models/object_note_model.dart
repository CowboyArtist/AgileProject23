import 'package:cloud_firestore/cloud_firestore.dart';

//An objectnote's different attributes
class ObjectNote {
  final String id;
  final String text;
  Timestamp timestamp;

  ObjectNote({this.id, this.text, this.timestamp});

//Method to create an objectnote from database document
  factory ObjectNote.fromDoc(DocumentSnapshot doc) {
    return ObjectNote(
      id: doc.documentID,
      text: doc['text'],
      timestamp: doc['timestamp'],
    );
  }
}
