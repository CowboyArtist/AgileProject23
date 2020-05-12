import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';

//A ContactModels different attributes
class ContactModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String description;
  bool isMainContact;
  // final Supplier supplier;

  ContactModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.description,
    this.isMainContact,
    //   this.supplier list of contacts in supplier?
  });

//Method to create an ContactModel from database document
  factory ContactModel.fromDoc(DocumentSnapshot doc) {
    return ContactModel(
      id: doc.documentID,
      name: doc['name'],
      phoneNumber: doc['phoneNumber'],
      email: doc['email'],
      description: doc['description'],
      isMainContact: doc['isMainContact'],
      //supplier: doc['supplier']
    );
  }
}
