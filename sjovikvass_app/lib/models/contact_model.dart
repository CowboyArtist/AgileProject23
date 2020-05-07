import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';

//A ContactModels different attributes
class ContactModel {
  final String name;
  final String phoneNumber;
  final String email;
  final String description;
  final bool mainContact;
  final Supplier supplier;

  ContactModel({
    this.name,
    this.phoneNumber,
    this.email,
    this.description,
    this.mainContact,
    this.supplier
  });

//Method to create an ContactModel from database document
  factory ContactModel.fromDoc(DocumentSnapshot doc) {
    return ContactModel(
      name: doc['name'],
      phoneNumber: doc['phoneNumber'],
      email: doc['email'],
      description: doc['description'],
      mainContact: doc['mainContact'],
      supplier: doc['supplier']
    );
  }
}
