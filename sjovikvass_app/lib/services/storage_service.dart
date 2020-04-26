import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sjovikvass_app/utils/constants.dart';
import 'package:uuid/uuid.dart';

class StorageService {

  static Future<File> compressImage(String photoId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 80,
    );
    return compressedImageFile;
  }

  
  //Used by boatImages.dart for adding images to a specific object
  static Future<String> uploadObjectImage(File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);

    StorageUploadTask uploadTask = storageRef
        .child('images/objects/object_$photoId.jpg')
        .putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  //Used by add_object_screen.dart to upload the image viewed in the landing screen.
   static Future<String> uploadObjectMainImage(File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);

    StorageUploadTask uploadTask = storageRef
        .child('images/objectsMain/object_$photoId.jpg')
        .putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }
}