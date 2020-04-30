import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sjovikvass_app/models/document_model.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/services/storage_service.dart';
import 'package:sjovikvass_app/utils/constants.dart';
import 'package:sjovikvass_app/models/boatImage_model.dart';

class DatabaseService {
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
        'storageType': storedObject.storageType,
        'serialnumber': storedObject.serialnumber,
        'billingSum': storedObject.billingSum + addToBillingSum,
      });
    });
  }

  static void updateObjectTotal(StoredObject storedObject) {
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
      'storageType': storedObject.storageType,
      'serialnumber': storedObject.serialnumber,
      'billingSum': storedObject.billingSum,
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
      'storageType': 'Typ av hall',
      'serialnumber': storedObject.serialnumber,
      'billingSum': 0.0,
    });
  }

  static Future<QuerySnapshot> getStoredObjectsFuture() {
    Future<QuerySnapshot> objects =
        objectsRef.orderBy('outDate', descending: false).getDocuments();

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

  static Future<int> getImageCount(String inObjectId) async {
    QuerySnapshot snapshot = await imageRef
        .document(inObjectId)
        .collection('hasImages')
        .getDocuments();

    return snapshot.documents.length;
  }

  //Methods for PDF uploads --------------------------------------------
  static void uploadDocument(DocumentModel documentModel, String inObjectId) {
    documentsRef.document(inObjectId).collection('hasDocuments').add({
      'fileUrl': documentModel.fileUrl,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'comment': documentModel.comment,
    });
  }

  static Stream getObjectDocuments(String inObjectId) {
    Stream docStream = documentsRef
        .document(inObjectId)
        .collection('hasDocuments')
        .snapshots();

    return docStream;
  }

  static void deleteDocument(String inObjectId, DocumentModel documentModel) {
    documentsRef
        .document(inObjectId)
        .collection('hasDocuments')
        .document(documentModel.id)
        .get()
        .then((doc) => {
              if (doc.exists)
                {
                  StorageService.deleteDocument(documentModel.fileUrl),
                  doc.reference.delete()
                }
            });
  }

  static Future<int> getDocumentsCount(String inObjectId) async {
    QuerySnapshot snapshot = await documentsRef
        .document(inObjectId)
        .collection('hasDocuments')
        .getDocuments();

    return snapshot.documents.length;
  }
}
