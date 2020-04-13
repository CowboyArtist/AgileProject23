import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/screens/object/object_screen.dart';

//This Widget will return the list of objects required by the user
class ObjectsList extends StatefulWidget {
  @override
  _ObjectsListState createState() => _ObjectsListState();
}

class _ObjectsListState extends State<ObjectsList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Listvy med object i objects_list.dart'),
          FlatButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ObjectScreen(object: StoredObject(title: 'Placeholderobjekt'),)),
              );
            }, child: Text('Öppna detaljvy'))
        ],
      ),
    );
  }
}