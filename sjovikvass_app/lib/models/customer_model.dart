import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String postalCode;
  final String city;
  final bool gdpr;
  final Timestamp timestamp;

  Customer({this.id, this.name, this.phone, this.email, this.address, this.postalCode, this.city, this.gdpr, this.timestamp});

  factory Customer.fromDoc(DocumentSnapshot doc) {
    return Customer(
        id: doc.documentID,
        name: doc['name'],
        phone: doc['phone'],
        email: doc['email'],
        address: doc['address'],
        postalCode: doc['postalCode'],
        city: doc['city'],
        gdpr: doc['gdpr'],
        timestamp: doc['timestamp']
        );
  }
}
