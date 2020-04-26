import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/screens/boatImages/boatImages.dart';
import 'package:sjovikvass_app/screens/addObject/add_object_screen.dart';
import 'package:sjovikvass_app/screens/object/object_screen.dart';
import 'package:sjovikvass_app/screens/workPage/work_page.dart';
import 'package:sjovikvass_app/services/database_service.dart';

//This Widget will return the list of objects required by the user
class ObjectsList extends StatefulWidget {
  @override
  _ObjectsListState createState() => _ObjectsListState();
}

class _ObjectsListState extends State<ObjectsList> {
  Future<QuerySnapshot> _objects;

  @override
  void initState() {
    super.initState();
    _setupObjects();
  }

  //Used to fetch objects from database
  _setupObjects() async {
    Future<QuerySnapshot> objects = DatabaseService.getStoredObjectsFuture();
    setState(() {
      _objects = objects;
    });
  }

  _buildObjectTile(StoredObject storedObject) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ObjectScreen(
            object: storedObject,
          ),
        ),
      ),
      child: Container(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          height: 100.0,
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(10.0)),
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: storedObject.imageUrl == null
                        ? Image.asset(
                            'assets/images/placeholder_boat.jpg',
                            fit: BoxFit.cover,
                          )
                        : Image(
                            image: CachedNetworkImageProvider(
                                storedObject.imageUrl),
                            fit: BoxFit.cover,
                          )),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ),
              Positioned(
                  left: 16.0,
                  bottom: 16.0,
                  child: Text(
                    storedObject.title,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: RefreshIndicator(
            //Pull down to refresh calls method _setupObjects
            onRefresh: () => _setupObjects(),
            child: FutureBuilder(
              future: _objects,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('Ingen data');
                }

                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      StoredObject storedObject =
                          StoredObject.fromDoc(snapshot.data.documents[index]);
                      return _buildObjectTile(storedObject);
                    });
              },
            ),
          ),
        )
      ],
    );
  }
}
