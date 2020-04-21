
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
      'imageUrl': storedObject.imageUrl,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'inDate': storedObject.inDate,
      'outDate': storedObject.outDate,
      'space': storedObject.space,
      'serialnumber': storedObject.serialnumber
    });
    print('Runs addObjectToDB with' + storedObject.title);
  }
}