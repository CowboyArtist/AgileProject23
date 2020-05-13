import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sjovikvass_app/models/customer_model.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/screens/object/object_screen.dart';
import 'package:sjovikvass_app/screens/objectNotes/object_notes.dart';
import 'package:sjovikvass_app/screens/workPage/work_page.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/circular_indicator.dart';

//This Widget will return the list of objects required by the user
class ObjectsList extends StatefulWidget {
  Future<QuerySnapshot> objects;
  Function objectsFutureGetter;
  String searchString;

  ObjectsList({this.objects, this.objectsFutureGetter, this.searchString});
  @override
  _ObjectsListState createState() => _ObjectsListState();
}

class _ObjectsListState extends State<ObjectsList> {
  @override
  void initState() {
    super.initState();
    _setupObjects();
  }

  Future<double> getPercentForObject(String id) async {
    int total = await DatabaseService.getTotalOrders(id);
    if (total == 0) {
      return 0.0;
    }
    int done = await DatabaseService.getDoneOrders(id);
    return done / total;
  }

  //Used to fetch objects from database
  _setupObjects() async {
    Future<QuerySnapshot> objects;

    objects = widget.objectsFutureGetter();

    setState(() {
      widget.objects = objects;
    });
  }

  _showDeleteAlertDialog(BuildContext context, StoredObject object) {
    Widget okButton = FlatButton(
      color: Colors.redAccent,
      child: Text("Radera"),
      onPressed: () {
        DatabaseService.removeObjectCascade(object.id, object.imageUrl);
        _setupObjects();
        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Avbryt"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Vill du ta bort ${object.title}?"),
      content: Text("Detta kan inte ångras i efterhand."),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _buildObjectTile(StoredObject storedObject) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ObjectScreen(object: storedObject),
        ),
      ),
      child: Container(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          height: 130.0,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0)),
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: <Widget>[
              IconSlideAction(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Colors.red,
                  caption: 'Radera Objekt',
                  icon: Icons.delete,
                  onTap: () => _showDeleteAlertDialog(context, storedObject)),
            ],
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          storedObject.title,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        storedObject.ownerId != null &&
                                storedObject.ownerId.isNotEmpty
                            ? FutureBuilder(
                                future: DatabaseService.getCustomerById(
                                    storedObject.ownerId),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text(
                                      'Laddar in ägare',
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                    );
                                  }

                                  if (!snapshot.data.exists) {
                                    return SizedBox.shrink();
                                  }
                                  Customer customer =
                                      Customer.fromDoc(snapshot.data);
                                  return Text(
                                    customer.name,
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  );
                                })
                            : SizedBox.shrink(),
                      ],
                    )),
                FutureBuilder(
                    future: getPercentForObject(storedObject.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == 0.0) {
                        return SizedBox.shrink();
                      }
                      return Positioned(
                        right: 30.0,
                        top: 30.0,
                        child: MyCircularProcentIndicator
                            .buildCustomIndicatorFromDouble(
                                snapshot.data, 70.0, Colors.white),
                      );
                    }),
              ],
            ),
          )),
    );
  }

  _dummyMethod() async {}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        //Pull down to refresh calls method _setupObjects
        onRefresh: widget.searchString == null
            ? () => _setupObjects()
            : () => _dummyMethod(),
        child: FutureBuilder(
          future: widget.objects,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: Container(
                height: 80.0,
                width: 80.0,
                child: CircularProgressIndicator(),
              ));
            }
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Text('Inga resultat'),
              );
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
    );
  }
}
