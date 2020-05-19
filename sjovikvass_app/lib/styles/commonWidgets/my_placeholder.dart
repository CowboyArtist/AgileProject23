import 'package:flutter/material.dart';

class MyPlaceholder extends StatelessWidget {
  final String assetPath;
  final String title;
  final String subtitle;

  MyPlaceholder({this.assetPath, this.title, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.0,
      height: 300.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          assetPath != null ? Image.asset(assetPath) : SizedBox(height: 120.0,),
          Text(title, style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w600)),
          Text(subtitle, textAlign: TextAlign.center,)
        ]
      ),
      
    );
  }
}