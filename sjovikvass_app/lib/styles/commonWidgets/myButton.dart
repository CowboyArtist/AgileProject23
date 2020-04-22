import 'package:flutter/material.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

class MyButton {
  static Column smallButton(Icon icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30.0),
        ButtonTheme(
          minWidth: 30.0,
          height: 30.0,
          child: RaisedButton(
            color: MyColors.lightBlue,
            child: icon,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            padding: EdgeInsets.all(10.0),
            onPressed: () => print(label),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 11.0,
          ),
        ),
      ],
    );
  }
}
