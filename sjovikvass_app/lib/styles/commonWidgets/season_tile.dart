import 'package:flutter/material.dart';

class SeasonTile extends StatelessWidget {
  final String season;

  SeasonTile({
    this.season,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black12,
      ),
      child: ListTile(
        title: Text(
          season,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      margin: EdgeInsets.all(8.0),
    );
  }
}