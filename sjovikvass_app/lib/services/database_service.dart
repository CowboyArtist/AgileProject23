import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/utils/constants.dart';

class DatabaseService {
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
      'serialnumber': storedObject.serialnumber
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
