import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sjovikvass_app/models/object_note_model.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/utils/constants.dart';
import 'package:sjovikvass_app/models/boatImage_model.dart';

class DatabaseService {
  // Methods for object notes --------------------------------

  static Stream getObjectNotes(String inObjectId) {
    Stream objectNotesStream =
        objectNotesRef.document(inObjectId).collection('hasNotes').snapshots();

    return objectNotesStream;
  }

  static void addNoteToObject(ObjectNote objectNote, String inObjectId) {
    objectNotesRef.document(inObjectId).collection('hasNotes').add({
      'text': objectNote.text,
      'timestamp': objectNote.timestamp,
    });
  }

  static Future<int> getAllObjectNotes(String inObjectId) async {
    QuerySnapshot snapshot = await objectNotesRef
        .document(inObjectId)
        .collection('hasNotes')
        .getDocuments();
    return snapshot.documents.length;
  }

  // Methods for work orders ---------------------------------

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
        .collection('hasWorkOrders')
        .where('isDone', isEqualTo: true)
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

  // Methods for an object ---------------------------------------

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
  }

  static Future<QuerySnapshot> getStoredObjectsFuture() {
    Future<QuerySnapshot> objects =
        objectsRef.orderBy('timestamp', descending: true).getDocuments();
    //Ändra till "outDate" när den finns.

    return objects;
  }

  //Methods for image uploads --------------------------------------------
  static void uploadImage(BoatImageModel boatImageModel, String inObjectId) {
    imageRef.document(inObjectId).collection('hasImages').add({
      'imageUrl': boatImageModel.imageUrl,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'comment': boatImageModel.comment,
    });
  }

  static Stream getObjectImages(String inObjectId) {
    Stream imageStream =
        imageRef.document(inObjectId).collection('hasImages').snapshots();

    return imageStream;
  }
}
