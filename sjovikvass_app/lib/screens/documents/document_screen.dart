import 'package:flutter/material.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

class DocumentScreen extends StatefulWidget {
  final String inObjectId;
  DocumentScreen({this.inObjectId});
  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
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
                      print('pdfUrl');
                      // OpenFile.open(pdfUrl.replaceAll("file://", ''))
                      //     .then((result) => debugPrint(result),
                      //     onError: (error) => displayError(context, error)
                      // );
                    }, onError: (error) => print(error));
                  },
                ),
                _buildBtn(Icons.file_upload, 'Ladda upp',
                    () => print('open FilePicker')),
                _buildBtn(Icons.add_a_photo, 'Ta bild',
                    () => print('open ImagePicker'))
              ]))
        ],
      ),
    );
  }
}
