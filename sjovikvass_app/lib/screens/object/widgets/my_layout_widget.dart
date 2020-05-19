import 'package:flutter/material.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

//Custom containers for object_screen.dart
class MyLayout {
  static oneItem(Widget child, Function onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
              child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          padding: EdgeInsets.all(11.0),
          decoration: BoxDecoration(
            color: MyColors.lightBlue,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0x11000000), blurRadius: 5.0, offset: Offset(2, 2))
            ],
          ),
          child: child,
        ),
      ),
    );

    
  }
  static oneItemNoExpand(Widget child, Function onTap) {
    return GestureDetector(
      onTap: onTap,
            child: Container(
              width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: MyColors.lightBlue,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
                color: Color(0x11000000), blurRadius: 5.0, offset: Offset(2, 2))
          ],
        ),
        child: child,
      ),
    );}

  
}
