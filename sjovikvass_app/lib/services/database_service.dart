import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/utils/constants.dart';

class DatabaseService {
  // Methods for work orders

  static Future<int> getTotalOrders(String inObjectId) async {
    QuerySnapshot snapshot = await workOrderRef
        .document(inObjectId)
        .collection('hasWorkOrders')
        .getDocuments();
    return snapshot.documents.length;
  }

  static Future<int> getDoneOrders(String inObjectId) async {
    QuerySnapshot snapshot = await workOrderRef
        .document(inObjectId)
        .collection('hasWorkOrders').where('isDone', isEqualTo: true)
        .getDocuments();
    return snapshot.documents.length;
  }


  static void updateWorkOrder(String inObjectId, WorkOrder workOrder) {
    workOrderRef
        .document(inObjectId)
        .collection('hasWorkOrders')
        .document(workOrder.id)
        .updateData({
      'title': workOrder.title,
      'isDone': workOrder.isDone,
      'sum': workOrder.sum,
    });
  }

  static Stream getWorkOrders(String inObjectId) {
    Stream workOrderStream = workOrderRef
        .document(inObjectId)
        .collection('hasWorkOrders')
        .snapshots();

    return workOrderStream;
  }

  static void addWorkOrderToObject(WorkOrder workOrder, String inObjectId) {
    workOrderRef.document(inObjectId).collection('hasWorkOrders').add({
      'title': workOrder.title,
      'isDone': workOrder.isDone,
      'sum': workOrder.sum,
    });
  }

  // Methods for an object

  static Future<DocumentSnapshot> getObjectById(String objectId) {
    Future<DocumentSnapshot> objectSnapshot =
        objectsRef.document(objectId).get();

    return objectSnapshot;
  }

  static void updateObject(String storedObjectId, double addToBillingSum) {
    StoredObject storedObject;
    getObjectById(storedObjectId).then((data) {
      storedObject = StoredObject.fromDoc(data);

      objectsRef.document(storedObject.id).updateData({
        'title': storedObject.title,
        'description': storedObject.description,
        'category': storedObject.category,
        'model': storedObject.model,
        'engine': storedObject.engine,
        'engineSerialnumber': storedObject.engineSerialnumber,
        'imageUrl': storedObject.imageUrl,
        'timestamp': storedObject.timestamp,
        'inDate': storedObject.inDate,
        'outDate': storedObject.outDate,
        'space': storedObject.space,
        'serialnumber': storedObject.serialnumber,
        'billingSum': storedObject.billingSum + addToBillingSum,
      });
    });
  }

  static void addObjectToDB(StoredObject storedObject) {
    objectsRef.add({
      'title': storedObject.title,
      'description': storedObject.description,
      'category': storedObject.category,
      'model': storedObject.model,
      'engine': storedObject.engine,
      'engineSerialnumber': storedObject.engineSerialnumber,
      'imageUrl': storedObject.imageUrl,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'inDate': storedObject.inDate,
      'outDate': storedObject.outDate,
      'space': storedObject.space,
      'serialnumber': storedObject.serialnumber,
      'billingSum': 0.0,
    });
    print('Runs addObjectToDB with' + storedObject.title);
  }

  static Future<List<StoredObject>> getStoredObjects() async {
    QuerySnapshot objectsSnapshot = await objectsRef.getDocuments();
    List<StoredObject> objects = objectsSnapshot.documents
        .map((doc) => StoredObject.fromDoc(doc))
        .toList();
    return objects;
  }

  static Future<QuerySnapshot> getStoredObjectsFuture() {
    Future<QuerySnapshot> objects =
        objectsRef.orderBy('timestamp', descending: true).getDocuments();
    //Ändra till "outDate" när den finns.

    return objects;
  }
}
