import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;

//References to different parts of the database for easy access in code
final storageRef = FirebaseStorage.instance.ref();
final objectsRef = _firestore.collection('storedObjects');
final workOrderRef = _firestore.collection('workOrders');
final imageRef = _firestore.collection('images');
final objectNotesRef = _firestore.collection('objectNotes');
final documentsRef = _firestore.collection('documents');
final suppliersRef = _firestore.collection('suppliers');
final workOrderMaterialsRef = _firestore.collection('workOrderMaterials');
final customerRef = _firestore.collection('customers');
