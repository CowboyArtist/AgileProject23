import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/screens/addObject/add_object_screen.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

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
      body: Center(
        child: new Row(
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddObjectScreen(),
                  )),
              child: Container(
                margin: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 40.0),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    color: MyColors.lightBlue,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(3, 3),
                          blurRadius: 5.0)
                    ],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                    child: Icon(
                  Icons.photo_camera,
                  size: 32.0,
                  color: MyColors.primary,
                )),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddObjectScreen(),
                  )),
              child: Container(
                margin: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 40.0),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    color: MyColors.lightBlue,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(3, 3),
                          blurRadius: 5.0)
                    ],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                    child: Icon(
                  Icons.build,
                  size: 32.0,
                  color: MyColors.primary,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
