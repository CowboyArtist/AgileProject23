import 'package:flutter/material.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';


class BoatImages extends StatefulWidget {
  @override
  _BoatImagesState createState() => _BoatImagesState();
}

class _BoatImagesState extends State<BoatImages> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar('Bilder'),
    );
  }
}
