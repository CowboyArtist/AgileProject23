import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class FullscreenDocument extends StatelessWidget {

  final PDFDocument document;
  FullscreenDocument({this.document});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PDFViewer(document: document),
    );
  }
}