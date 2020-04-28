import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/screens/boatImages/boatImages.dart';
import 'package:sjovikvass_app/screens/documents/document_screen.dart';
import 'package:sjovikvass_app/screens/workPage/work_page.dart';
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
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 200.0,
                width: double.infinity,
                child: widget.object.imageUrl == null
                    ? Image.asset('assets/images/placeholder_boat.jpg',
                        fit: BoxFit.cover)
                    : Image(
                        image:
                            CachedNetworkImageProvider(widget.object.imageUrl),
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black54],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                left: 22.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.object.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0),
                    ),
                    Text(
                      widget.object.description,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    )
                  ],
                ),
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            height: 170.0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: MyColors.lightBlue,
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.swap_horiz,
                              size: 44.0, color: MyColors.primary),
                          Column(
                            children: <Widget>[
                              widget.object.inDate != null
                                  ? Text(
                                      'In: ${widget.object.inDate.toDate().toLocal().toString()}')
                                  : Text('Indata ej angett'),
                              widget.object.outDate != null
                                  ? Text(
                                      'Ut: ${widget.object.outDate.toDate().toLocal().toString()}')
                                  : Text('Utdata ej angett'),
                            ],
                          ),
                          Text(widget.object.storageType, style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        color: MyColors.lightBlue,
                        borderRadius: BorderRadius.circular(16.0)),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton.icon(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BoatImages(
                            inObjectId: widget.object.id,
                          ),
                        ),
                      ),
                  icon: Icon(Icons.photo),
                  label: Text('Bilder')),
              RaisedButton.icon(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => WorkPage(
                              inObjectId: widget.object.id,
                            ))),
                icon: Icon(Icons.check_box),
                label: Text('Arbete'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton.icon(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DocumentScreen(
                            inObjectId: widget.object.id,
                          ),
                        ),
                      ),
                  icon: Icon(Icons.archive),
                  label: Text('Dokument')),
              RaisedButton.icon(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => WorkPage(
                              inObjectId: widget.object.id,
                            ))),
                icon: Icon(Icons.check_box),
                label: Text('Arbete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
