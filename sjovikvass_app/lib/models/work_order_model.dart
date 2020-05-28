import 'package:cloud_firestore/cloud_firestore.dart';

//A workorders different attributes
class WorkOrder {
  final String id;
  final String title;
  bool isDone;
  double sum;

  WorkOrder({
    this.id,
    this.title,
    this.isDone,
    this.sum
  });

//Method to create an WorkOrder from database document
factory WorkOrder.fromDoc(DocumentSnapshot doc) {
    return WorkOrder(
      id: doc.documentID,
      title: doc['title'],
      isDone: doc['isDone'],
      sum: doc['sum'],
    );
  }

}