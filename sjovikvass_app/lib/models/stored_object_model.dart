import 'package:cloud_firestore/cloud_firestore.dart';

class StoredObject {
  final String id;
  final String title;
  final String description;
  final String category;
  final String model;
  final String serialnumber;
  final String engine;
  final String engineSerialnumber;
  final String imageUrl;
  final double space;
  final Timestamp timestamp;

  final double billingSum;

  final Timestamp inDate;
  final Timestamp outDate;

  StoredObject({
    this.id,
    this.title,
    this.category,
    this.description,
    this.engine,
    this.engineSerialnumber,
    this.model,
    this.serialnumber,
    this.imageUrl,
    this.space,
    this.timestamp,
    this.inDate,
    this.outDate,
    this.billingSum,
  });

  factory StoredObject.fromDoc(DocumentSnapshot doc) {
    return StoredObject(
      id: doc.documentID,
      title: doc['title'],
      description: doc['description'],
      category: doc['category'],
      engine: doc['engine'],
      engineSerialnumber: doc['engineSerialnumber'],
      model: doc['model'],
      serialnumber: doc['serialnumber'],
      imageUrl: doc['imageUrl'],
      timestamp: doc['timestamp'],
      space: doc['space'],
      inDate: doc['inDate'],
      outDate: doc['outDate'],
      billingSum: doc['billingSum'],
    );
  }
}

