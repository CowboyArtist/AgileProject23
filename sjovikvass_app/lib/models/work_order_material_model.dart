import 'package:cloud_firestore/cloud_firestore.dart';

//A workorder's materials different attributes
class WorkOrderMaterial {
  final String id;
  final String title;
  double amount;
  double cost;

  WorkOrderMaterial({this.id, this.title, this.amount, this.cost});

//Method to create an WorkOrderMaterial from database document
  factory WorkOrderMaterial.fromDoc(DocumentSnapshot doc) {
    return WorkOrderMaterial(
      id: doc.documentID,
      title: doc['title'],
      amount: doc['amount'],
      cost: doc['cost'],
    );
  }
}
