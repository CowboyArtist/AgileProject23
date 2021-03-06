import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sjovikvass_app/models/document_model.dart';
import 'package:sjovikvass_app/screens/documents/document_full_screen.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/storage_service.dart';
import 'package:sjovikvass_app/services/time_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/commonWidgets/my_placeholder.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:open_file/open_file.dart';

//Screen to view all ddocuments added to an object
class DocumentScreen extends StatefulWidget {
  final String inObjectId;
  DocumentScreen({this.inObjectId});
  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  File _scannedFile;

  _submitFile() async {
    String dbFileUrl = await StorageService.uploadScannedPdf(_scannedFile);
    DocumentModel documentModel = DocumentModel(fileUrl: dbFileUrl);
    DatabaseService.uploadDocument(documentModel, widget.inObjectId);
  }

  _showDeleteAlertDialog(BuildContext context, DocumentModel document) {
    Widget okButton = FlatButton(
      color: Colors.redAccent,
      child: Text("Radera"),
      onPressed: () {
        DatabaseService.deleteDocument(widget.inObjectId, document);

        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Avbryt"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Vill du ta bort dokumentet?"),
      content: Text("Detta kan inte ångras i efterhand."),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _buildDocumentTile(DocumentModel document) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
            color: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Colors.red,
            caption: 'Ta bort',
            icon: Icons.delete,
            onTap: () => _showDeleteAlertDialog(context, document)),
      ],
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, offset: Offset(3, 3), blurRadius: 5.0)
            ]),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: ListTile(
          title: Text(TimeService.getFormattedDateWithTime(
              document.timestamp.toDate())),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullscreenDocument(
                documentUrl: document.fileUrl,
              ),
            ),
          ),
        ),
      ),
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
          ),
          StreamBuilder(
            stream: DatabaseService.getObjectDocuments(widget.inObjectId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Text('Laddar in dokument');
              }
              if (snapshot.data.documents.length == 0) {
                return Center(child: MyPlaceholder(icon: Icons.pages, title: 'Det finns inga dokument', subtitle: 'Skanna in nya datumstämplade dokument med knappen nedan.',));
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
      bottomNavigationBar: GestureDetector(
        onTap: () {
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
        child: Container(
            margin: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 40.0),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: MyColors.primary,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3, 3),
                      blurRadius: 5.0)
                ],
                borderRadius: BorderRadius.circular(10.0)),
            child: Center(
                child: Text(
              'Nytt dokument',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }
}
