import 'package:flutter/material.dart';

import '../my_colors.dart';

class MyButton extends StatelessWidget {
  final IconData icon;
  final GestureTapCallback onTap;

  MyButton({this.icon, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: MyColors.primary, borderRadius: BorderRadius.circular(5.0)),
        child: Icon(
          icon,
          size: 15.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MyLightBlueButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final GestureTapCallback onTap;

  MyLightBlueButton({this.icon, this.label, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ButtonTheme(
          minWidth: 30.0,
          height: 30.0,
          child: RaisedButton(
            color: MyColors.lightBlue,
            child: Icon(
              icon,
              color: MyColors.primary,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            padding: EdgeInsets.all(10.0),
            onPressed: () => onTap,
          ),
        ),
        Text(label),
      ],
    );
  }
}
