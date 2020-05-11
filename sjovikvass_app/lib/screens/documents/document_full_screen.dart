import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

//Builds screen for being able to go thru pages in pdf.
class FullscreenDocument extends StatelessWidget {
  final String documentUrl;
  FullscreenDocument({this.documentUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<PDFDocument>(
        future: PDFDocument.fromURL(documentUrl),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            // Show document
            return PDFViewer(showPicker: false, document: snapshot.data);
          }

          if (snapshot.hasError) {
            // Catch
            return Center(
              child: Text(
                'PDF Rendering does not '
                'support on the system of this version',
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
