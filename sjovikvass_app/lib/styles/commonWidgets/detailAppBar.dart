import 'package:flutter/material.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

//Custom AppBar for the entire app.
class DetailAppBar {
  static AppBar buildAppBar(String title, BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.only(left: 5.0),
        child: InkResponse(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: MyColors.backgroundLight,
    );
  }
}
