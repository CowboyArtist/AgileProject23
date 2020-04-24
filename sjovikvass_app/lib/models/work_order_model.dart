import 'package:cloud_firestore/cloud_firestore.dart';


class WorkOrder {
  final String id;
  final String title;
  bool isDone;
  final double sum;

  WorkOrder({
    this.id,
    this.title,
    this.isDone,
    this.sum
  });

factory WorkOrder.fromDoc(DocumentSnapshot doc) {
    return WorkOrder(
      id: doc.documentID,
      title: doc['title'],
      isDone: doc['isDone'],
      sum: doc['sum'],
    );
  }

}