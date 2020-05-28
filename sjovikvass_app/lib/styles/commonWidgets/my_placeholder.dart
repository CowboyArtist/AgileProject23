import 'package:flutter/material.dart';

//Widget used for easily create placeholder with same design thruout the app.
class MyPlaceholder extends StatelessWidget {
  final String assetPath; 
  final String title;
  final String subtitle;
  final IconData icon;

  MyPlaceholder({this.assetPath, this.title, this.subtitle, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.0,
      height: 300.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          //If the widgets constructor gets a icon it's overriding the image. 
          //If it has image but icon is null it shows the image
          icon != null ? Container( height: 180, child: Icon(icon, size: 66.0, color: Colors.black38,)) :
          assetPath != null ? Image.asset(assetPath) : SizedBox(height: 120.0,),
          Text(title, style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w600)),
          Text(subtitle, textAlign: TextAlign.center,)
        ]
      ),
      
    );
  }
}