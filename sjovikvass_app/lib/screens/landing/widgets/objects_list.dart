import 'package:flutter/material.dart';

//This Widget will return the list of objects required by the user
class ObjectsList extends StatefulWidget {
  @override
  _ObjectsListState createState() => _ObjectsListState();
}

class _ObjectsListState extends State<ObjectsList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Listvy med object i objects_list.dart'),
    );
  }
}