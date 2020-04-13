import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';


//The screen that shows the overview of one specific object.
class ObjectScreen extends StatefulWidget {
  
  final StoredObject object;
  ObjectScreen({this.object});

  @override
  _ObjectScreenState createState() => _ObjectScreenState();
}

class _ObjectScreenState extends State<ObjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detaljvy')),
     body: Center(child: Text( 'Vy för: ${widget.object.title}')),
    );
  }
}