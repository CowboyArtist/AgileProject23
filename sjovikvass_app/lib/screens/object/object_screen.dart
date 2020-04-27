import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/screens/boatImages/boatImages.dart';
import 'package:sjovikvass_app/screens/documents/document_screen.dart';
import 'package:sjovikvass_app/screens/workPage/work_page.dart';

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
                height: 240.0,
                width: double.infinity,
                child: widget.object.imageUrl == null ?  Image.asset('assets/images/placeholder_boat.jpg',
                    fit: BoxFit.cover)
                    : 
                    Image(image: CachedNetworkImageProvider(widget.object.imageUrl), fit: BoxFit.cover,)
                    ,
              ),
              Container(
                height: 240.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black54],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                    child: Text(
                  widget.object.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0),
                )),
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
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
