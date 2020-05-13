import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sjovikvass_app/models/archive_model.dart';
import 'package:sjovikvass_app/models/contact_model.dart';
import 'package:sjovikvass_app/models/customer_model.dart';
import 'package:sjovikvass_app/models/document_model.dart';
import 'package:sjovikvass_app/models/object_note_model.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';
import 'package:sjovikvass_app/models/work_order_material_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/services/storage_service.dart';
import 'package:sjovikvass_app/utils/constants.dart';
import 'package:sjovikvass_app/models/boatImage_model.dart';

class DatabaseService {
//Methods for Notes ---------------------------------------
  static Stream getObjectNotes(String inObjectId) {
    Stream objectNotesStream = objectNotesRef
        .document(inObjectId)
        .collection('hasNotes')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return objectNotesStream;
  }

  static void addNoteToObject(ObjectNote objectNote, String inObjectId) {
    objectNotesRef.document(inObjectId).collection('hasNotes').add({
      'text': objectNote.text,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }

  static Future<int> countNotesInObject(String inObjectId) async {
    QuerySnapshot notesSnapshot = await objectNotesRef
        .document(inObjectId)
        .collection('hasNotes')
        .getDocuments();
    return notesSnapshot.documents.length;
  }

  static void removeNote(String inObjectId, String noteId) {
    objectNotesRef
        .document(inObjectId)
        .collection('hasNotes')
        .document(noteId)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
  }

  static void removeAllNotesForObject(String inObjectId) {
    objectNotesRef
        .document(inObjectId)
        .collection('hasNotes')
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        if (element.exists) {
          element.reference.delete();
        }
      });
    });
  }

  // Methods for work orders ---------------------------------

  static Future<DocumentSnapshot> getWorkOrderById(
      String inWorkOrderId, String inObjectId) {
    Future<DocumentSnapshot> workOrderSnapshot = workOrderRef
        .document(inObjectId)
        .collection('hasWorkOrders')
        .document(inWorkOrderId)
        .get();
    return workOrderSnapshot;
  }

  static void updateWorkOrderSum(
      String inObjectId, String inWorkOrderId, double amount) {
    WorkOrder workOrder;
    getWorkOrderById(inWorkOrderId, inObjectId).then((data) {
      workOrder = WorkOrder.fromDoc(data);

      workOrderRef
          .document(inObjectId)
          .collection('hasWorkOrders')
          .document(workOrder.id)
          .updateData({
        'sum': workOrder.sum + amount,
      });
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

  static void removeAllWorkOrdersForObject(String inObjectId) {
    workOrderRef
        .document(inObjectId)
        .collection('hasWorkOrders')
        .getDocuments()
        .then((docs) => {
              docs.documents.forEach((element) {
                if (element.exists) {
                  removeAllMaterialsForWorkOrder(element.documentID);
                  element.reference.delete();
                }
              })
            });
  }

  static void removeWorkOrder(String inObjectId, String workOrderId) {
    workOrderRef
        .document(inObjectId)
        .collection('hasWorkOrders')
        .document(workOrderId)
        .get()
        .then((doc) {
      if (doc.exists) {
        removeAllMaterialsForWorkOrder(workOrderId);
        doc.reference.delete();
      }
    });
  }

  // Methods for WorkOrderMaterials

  static void addMaterialToWorkOrder(
      String inWorkOrderId, WorkOrderMaterial workOrderMaterial) {
    workOrderMaterialsRef
        .document(inWorkOrderId)
        .collection('hasMaterialItems')
        .add({
      'title': workOrderMaterial.title,
      'amount': workOrderMaterial.amount,
      'cost': workOrderMaterial.cost,
    });
  }

  static void removeAllMaterialsForWorkOrder(String inWorkOrderId) {
    workOrderMaterialsRef
        .document(inWorkOrderId)
        .collection('hasMaterialItems')
        .getDocuments()
        .then((docs) => {
              docs.documents.forEach((element) {
                if (element.exists) {
                  element.reference.delete();
                }
              })
            });
  }

  static void removeMaterialToWorkOrder(
      String inWorkOrderId, WorkOrderMaterial workOrderMaterial) {
    workOrderMaterialsRef
        .document(inWorkOrderId)
        .collection('hasMaterialItems')
        .document(workOrderMaterial.id)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
  }

  static Stream getWorkOrderMaterials(String inWorkOrderId) {
    Stream workOrderMaterials = workOrderMaterialsRef
        .document(inWorkOrderId)
        .collection('hasMaterialItems')
        .orderBy('title', descending: false)
        .snapshots();

    return workOrderMaterials;
  }

  static Future<int> getNrMaterials(String inWorkOrderId) async {
    QuerySnapshot snap = await workOrderMaterialsRef
        .document(inWorkOrderId)
        .collection('hasMaterialItems')
        .getDocuments();
    return snap.documents.length;
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
        'year': storedObject.year,
        'engine': storedObject.engine,
        'engineSerialnumber': storedObject.engineSerialnumber,
        'engineYear': storedObject.engineYear,
        'imageUrl': storedObject.imageUrl,
        'timestamp': storedObject.timestamp,
        'inDate': storedObject.inDate,
        'outDate': storedObject.outDate,
        'space': storedObject.space,
        'storageType': storedObject.storageType,
        'serialnumber': storedObject.serialnumber,
        'billingSum': storedObject.billingSum + addToBillingSum,
        'ownerId': storedObject.ownerId
      });
    });
  }

  static void updateObjectTotal(StoredObject storedObject) {
    objectsRef.document(storedObject.id).updateData({
      'title': storedObject.title,
      'description': storedObject.description,
      'category': storedObject.category,
      'model': storedObject.model,
      'year': storedObject.year,
      'engine': storedObject.engine,
      'engineSerialnumber': storedObject.engineSerialnumber,
      'engineYear': storedObject.engineYear,
      'imageUrl': storedObject.imageUrl,
      'timestamp': storedObject.timestamp,
      'inDate': storedObject.inDate,
      'outDate': storedObject.outDate,
      'space': storedObject.space,
      'storageType': storedObject.storageType,
      'serialnumber': storedObject.serialnumber,
      'billingSum': storedObject.billingSum,
      'ownerId': storedObject.ownerId
    });
  }

  static void addObjectToDB(StoredObject storedObject) {
    objectsRef.add({
      'title': storedObject.title,
      'description': storedObject.description,
      'category': storedObject.category,
      'model': storedObject.model,
      'year': storedObject.year,
      'engine': storedObject.engine,
      'engineSerialnumber': storedObject.engineSerialnumber,
      'engineYear': storedObject.engineYear,
      'imageUrl': storedObject.imageUrl,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'inDate': storedObject.inDate,
      'outDate': storedObject.outDate,
      'space': storedObject.space,
      'storageType': 'Hall ej angedd',
      'serialnumber': storedObject.serialnumber,
      'billingSum': 0.0,
      'ownerId': storedObject.ownerId
    });
  }

  static void removeObjectCascade(String objectId, String objectImageUrl) {
    objectsRef.document(objectId).get().then((value) {
      if (value.exists) {
        removeAllWorkOrdersForObject(objectId);
        removeAllObjectImages(objectId);
        removeAllNotesForObject(objectId);
        StorageService.deleteObjectMainImage(objectImageUrl);
        value.reference.delete();
      }
    });
  }

  static Future<QuerySnapshot> getStoredObjectsFuture() {
    Future<QuerySnapshot> objects =
        objectsRef.orderBy('outDate', descending: false).getDocuments();

    return objects;
  }

  static Future<QuerySnapshot> getStoredObjectsSearch(String searchString) {
    Future<QuerySnapshot> objects = objectsRef
        .where('title', isGreaterThanOrEqualTo: searchString)
        .getDocuments();

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

  static void removeAllObjectImages(String inObjectId) {
    imageRef
        .document(inObjectId)
        .collection('hasImages')
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        if (element.exists) {
          StorageService.deleteObjectImage(element['imageUrl']);
          element.reference.delete();
        }
      });
    });
  }

  static void removeOneImage(String inObjectId, String imageId) {
    imageRef
        .document(inObjectId)
        .collection('hasImages')
        .document(imageId)
        .get()
        .then((value) {
      if (value.exists) {
        StorageService.deleteObjectImage(value['imageUrl']);
        value.reference.delete();
      }
    });
  }

  //Methods for supplier -----------------------------------------------

  static Future<DocumentSnapshot> getSupplierById(String supplierId) {
    Future<DocumentSnapshot> supplierSnapshot =
        suppliersRef.document(supplierId).get();
    return supplierSnapshot;
  }

  static void updateSupplier(String supplierId) {
    Supplier supplier;
    getSupplierById(supplierId).then((data) {
      supplier = Supplier.fromDoc(data);

      suppliersRef.document(supplier.id).updateData({
        'companyName': supplier.companyName,
        'description': supplier.description,
        'phoneNr': supplier.phoneNr,
        'email': supplier.email,
        'imageUrl': supplier.imageUrl,
        'mainContact': supplier.mainContact,
      });
    });
  }

  static void updateSupplierMainContact(
      String supplierId, String contactModelId) {
    Supplier supplier;
    getSupplierById(supplierId).then((data) {
      supplier = Supplier.fromDoc(data);

      suppliersRef.document(supplier.id).updateData({
        'companyName': supplier.companyName,
        'description': supplier.description,
        'phoneNr': supplier.phoneNr,
        'email': supplier.email,
        'imageUrl': supplier.imageUrl,
        'mainContact': contactModelId,
      });
    });
  }

  static void addSupplierToDB(Supplier supplier) {
    suppliersRef.add({
      'companyName': supplier.companyName,
      'description': supplier.description,
      'phoneNr': supplier.phoneNr,
      'email': supplier.email,
      'imageUrl': supplier.imageUrl,
    });
  }

  static Future<QuerySnapshot> getSuppliersFuture() {
    Future<QuerySnapshot> suppliers =
        suppliersRef.orderBy('companyName').getDocuments();
    return suppliers;
  }

  static void removeSupplier(String supplierId) {
    suppliersRef.document(supplierId).get().then((value) {
      if (value.exists) {
        value.reference.delete();
        //TODO Cascade function to remove contactperons aswell.
      }
    });
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

  static void removeAllObjectDocuments(String inObjectId) {
    documentsRef
        .document(inObjectId)
        .collection('hasDocuments')
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        if (element.exists) {
          StorageService.deleteDocument(element['fileUrl']);
          element.reference.delete();
        }
      });
    });
  }

  //Methods for Customer ---------------------------------
  static void addCustomer(Customer customer) {
    customerRef.add({
      'name': customer.name,
      'address': customer.address,
      'postalCode': customer.postalCode,
      'city': customer.city,
      'phone': customer.phone,
      'email': customer.email,
      'gdpr': customer.gdpr,
      'timestamp': Timestamp.fromDate(DateTime.now())
    });
  }

  static void updateCustomer(Customer customer) {
    customerRef.document(customer.id).updateData({
      'name': customer.name,
      'address': customer.address,
      'postalCode': customer.postalCode,
      'city': customer.city,
      'phone': customer.phone,
      'email': customer.email,
      'gdpr': customer.gdpr,
      'timestamp': customer.timestamp
    });
  }

  static void deleteCustomerById(String customerId) {
    customerRef.document(customerId).get().then((value) => {
          if (value.exists) {value.reference.delete()}
        });
  }

  static Future<DocumentSnapshot> getCustomerById(String customerId) {
    Future<DocumentSnapshot> customerSnap =
        customerRef.document(customerId).get();
    return customerSnap;
  }

  //Methods for contacts ---------------------------

  static void updateContact(String inSupplierId, ContactModel contactModel) {
    contactsRef
        .document(inSupplierId)
        .collection('hasContacts')
        .document(contactModel.id)
        .updateData({
      'name': contactModel.name,
      'descripion': contactModel.description,
      'phoneNumber': contactModel.phoneNumber,
      'email': contactModel.email,
      'isMainContact': contactModel.isMainContact,
    });
  }

  static void updateContactIsMainContact(
      String inSupplierId, String contactId) {
    contactsRef
        .document(inSupplierId)
        .collection('hasContacts')
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        if (element.exists && element.documentID != contactId) {
          element.reference.updateData({
            'isMainContact': false,
          });
        } else {
          element.reference.updateData({
            'isMainContact': true,
          });
        }
      });
    });
  }

  static Stream getContacts(String inSupplierId) {
    Stream contactsStream = contactsRef
        .document(inSupplierId)
        .collection('hasContacts')
        .snapshots();

    return contactsStream;
  }

  static void addContactToSupplier(ContactModel contact, String inSupplierId) {
    contactsRef.document(inSupplierId).collection('hasContacts').add({
      'name': contact.name,
      'description': contact.description,
      'phoneNumber': contact.phoneNumber,
      'email': contact.email,
      'isMainContact': contact.isMainContact,
    });
  }

  static void removeContact(String inSupplierId, String contactId) {
    contactsRef
        .document(inSupplierId)
        .collection('hasContacts')
        .document(contactId)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
  }

  //METHODS FOR ARCHIVE ----------------------------

  static void addArchiveObject(String season, String inObjectId) {
    archiveRef.document(season).collection('hasArchive').add({}).then((value) {
      getObjectById(inObjectId).then((doc) {
        archiveRef
            .document(season)
            .collection('hasArchive')
            .document(value.documentID)
            .updateData({
          'season': season,
          'objectTitle': doc['title'],
          'objectId': inObjectId,
          'billingSum': doc['billingSum'],
          'ownerId': doc['ownerId'],
          'isBilled': doc['isBilled'],
        });
      });
      workOrderRef
          .document(inObjectId)
          .collection('hasWorkOrders')
          .getDocuments()
          .then((docs) {
        docs.documents.forEach((element) {
          workOrderRef
              .document(value.documentID)
              .collection('hasWorkOrders')
              .document(element.documentID)
              .setData({
            'title': element['title'],
            'isDone': element['isDone'],
            'sum': element['sum']
          });
          element.reference.delete();
        });
      });
    });
  }

  static Stream getArchiveForSeason(String season) {
    Stream archiveStream =
        archiveRef.document(season).collection('hasArchive').snapshots();

    return archiveStream;
  }

  static Stream getArchiveForObject(String objectId, String season) {
    Stream objectArchiveStream = archiveRef
        .document(season)
        .collection('hasArchive')
        .where('objectId', isEqualTo: objectId)
        .snapshots();
    return objectArchiveStream;
  }

  static Future<List<String>> getSeasonsForObjectArchive(
      String objectId) async {
    List<String> seasons = [];
    archiveRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        archiveRef
            .document(element.documentID)
            .collection('hasArchive')
            .where('objectId', isEqualTo: objectId)
            .getDocuments()
            .then((data) {
          if (data.documents.length > 0) {
            seasons.add(element.documentID);
          }
        });
      });
    });
    print('This is seasons length' + seasons.length.toString());
    return seasons;
  }

  static void updateArchiveIsBilled(
      String archiveId, String season, bool value) {
    archiveRef
        .document(season)
        .collection('hasArchive')
        .document(archiveId)
        .updateData({
      'isBilled': value,
    });
  }
}
