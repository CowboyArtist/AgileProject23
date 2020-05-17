import 'package:cloud_firestore/cloud_firestore.dart';

class Supplier {
  final String id;
  final String companyName;
  final String description;
  final String imageUrl;
  String mainContact;

  Supplier(
      {this.id,
      this.companyName,
      this.description,
      this.imageUrl,
      this.mainContact});

  //Method to create a Supplier from database document

  factory Supplier.fromDoc(DocumentSnapshot doc) {
    return Supplier(
      id: doc.documentID,
      companyName: doc['companyName'],
      description: doc['description'],
      imageUrl: doc['imageUrl'],
      mainContact: doc['mainContact'],
    );
  }
}
