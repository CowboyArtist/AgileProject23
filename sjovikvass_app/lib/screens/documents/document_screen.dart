
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sjovikvass_app/models/document_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/handle_image_service.dart';
import 'package:sjovikvass_app/services/storage_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:open_file/open_file.dart';

class DocumentScreen extends StatefulWidget {
  final String inObjectId;
  DocumentScreen({this.inObjectId});
  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  File _scannedFile;

  _buildBtn(IconData icon, String label, Function onPressed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
              color: MyColors.lightBlue,
              borderRadius: BorderRadius.circular(10.0)),
          child: IconButton(icon: Icon(icon), onPressed: onPressed),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(label)
      ],
    );
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      setState(() {
        //_imageUrl = imageUrl;
        //_image = imageFile;
      });
    }
  }

  _submitFile() async {
    String dbFileUrl = await StorageService.uploadScannedPdf(_scannedFile);
    DocumentModel documentModel = DocumentModel(fileUrl: dbFileUrl);
    DatabaseService.uploadDocument(documentModel, widget.inObjectId);
  }

  _buildDocumentTile(DocumentModel document) {
    
    return ListTile(
      title: Text(document.timestamp.toDate().toString()),
      onTap: () => OpenFile.open(document.fileUrl),
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar('Dokument', context),
      body: Column(
        children: <Widget>[
          Container(
              height: 140.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildBtn(
                      Icons.scanner,
                      'Skanna ny',
                      () {
                        FlutterGeniusScan.scanWithConfiguration({
                          'source': 'camera',
                          'multiPage': true,
                        }).then((result) {
                          String pdfUrl = result['pdfUrl'];
                          setState(() {
                            _scannedFile = File(pdfUrl.replaceAll("file://", ''));
                          });
                          OpenFile.open(pdfUrl.replaceAll("file://", '')).then(
                              (result) => debugPrint(result),
                              onError: (error) => print(error));
                          _submitFile();
                        }, onError: (error) => print(error));
                      },
                    ),
                    _buildBtn(Icons.file_upload, 'Ladda upp',
                        () => print('open FilePicker')),
                    _buildBtn(
                        Icons.add_a_photo,
                        'Ta bild',
                        () => ImageService.showSelectImageDialog(
                            context, _handleImage))
                  ])),
          StreamBuilder(
            stream: DatabaseService.getObjectDocuments(widget.inObjectId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Text('Laddar in dokument');
              }
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      //Translates database documents to a BoatImageModel object.
                      DocumentModel document =
                          DocumentModel.fromDoc(snapshot.data.documents[index]);
                      return _buildDocumentTile(document);
                    }),
              );
            },
          )
        ],
      ),
    );
  }
}
