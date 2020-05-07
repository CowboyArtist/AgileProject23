import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sjovikvass_app/models/contact_model.dart';

class Supplier {
  final String id;
  final String companyName;
  final String description;
  final String phoneNr;
  final String email;
  final String imageUrl;

  Supplier({
    this.id,
    this.companyName,
    this.description,
    this.phoneNr,
    this.email,
    this.imageUrl,
  });

  //Method to create a Supplier from database document

  factory Supplier.fromDoc(DocumentSnapshot doc) {
    return Supplier(
      id: doc.documentID,
      companyName: doc['companyName'],
      description: doc['description'],
      phoneNr: doc['phoneNr'],
      email: doc['email'],
      imageUrl: doc['imageUrl'],
    );
  }
}
