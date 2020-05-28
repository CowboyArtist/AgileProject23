import 'package:cloud_firestore/cloud_firestore.dart';

//A ContactModels different attributes
class ContactModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  bool isMainContact;

  ContactModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.isMainContact,
  });

//Method to create an ContactModel from database document
  factory ContactModel.fromDoc(DocumentSnapshot doc) {
    return ContactModel(
      id: doc.documentID,
      name: doc['name'],
      phoneNumber: doc['phoneNumber'],
      email: doc['email'],
      isMainContact: doc['isMainContact'],
    );
  }
}
