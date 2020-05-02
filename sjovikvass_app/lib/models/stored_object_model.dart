import 'package:cloud_firestore/cloud_firestore.dart';

//A objects different attributes
class StoredObject {
  final String id;
  final String title;
  final String description;
  final String category;
  final String model;
  final String serialnumber;
  final int year;
  final String engine;
  final String engineSerialnumber;
  final int engineYear;
  final String imageUrl;
  final double space;
  String storageType;
  final Timestamp timestamp;

  final double billingSum;

  final Timestamp inDate;
  final Timestamp outDate;

  StoredObject({
    this.id,
    this.title,
    this.category,
    this.description,
    this.year,
    this.engine,
    this.engineSerialnumber,
    this.engineYear,
    this.model,
    this.serialnumber,
    this.imageUrl,
    this.space,
    this.storageType,
    this.timestamp,
    this.inDate,
    this.outDate,
    this.billingSum,
  });

//Method to create an StoredObject from database document

  factory StoredObject.fromDoc(DocumentSnapshot doc) {
    return StoredObject(
      id: doc.documentID,
      title: doc['title'],
      description: doc['description'],
      category: doc['category'],
      year: doc['year'],
      engine: doc['engine'],
      engineSerialnumber: doc['engineSerialnumber'],
      engineYear: doc['engineYear'],
      model: doc['model'],
      serialnumber: doc['serialnumber'],
      imageUrl: doc['imageUrl'],
      timestamp: doc['timestamp'],
      space: doc['space'],
      storageType: doc['storageType'],
      inDate: doc['inDate'],
      outDate: doc['outDate'],
      billingSum: doc['billingSum'],
    );
  }
}

