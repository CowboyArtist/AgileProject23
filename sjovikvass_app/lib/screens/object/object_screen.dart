import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/customer_model.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/screens/boatImages/boatImages.dart';
import 'package:sjovikvass_app/screens/documents/document_screen.dart';
import 'package:sjovikvass_app/screens/object/widgets/in_out_dialog.dart';
import 'package:sjovikvass_app/screens/object/widgets/my_layout_widget.dart';
import 'package:sjovikvass_app/screens/object/widgets/owner_widget.dart';
import 'package:sjovikvass_app/screens/workPage/work_page.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/time_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/circular_indicator.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

//The screen that shows the overview of one specific object.
class ObjectScreen extends StatefulWidget {
  final StoredObject object;
  ObjectScreen({this.object});

  @override
  _ObjectScreenState createState() => _ObjectScreenState();
}

class _ObjectScreenState extends State<ObjectScreen> {
  Future<void> _launched;

  int _doneOrders = 0;
  int _totalOrders = 0;
  int _imageCount = 0;
  int _documentCount = 0;

  Future<DocumentSnapshot> _dynamicOwner;

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(14.0),
    topRight: Radius.circular(14.0),
  );

  PanelController _pc = new PanelController();
  PanelController _pcOwner = new PanelController();

  Future<DocumentSnapshot> _dynamicObject;

  @override
  void initState() {
    super.initState();
    _setupOrderCounts();
    _setupImageCount();
    _setupDocumentCount();
    setupDynamicFields();
    setupOwner();
  }

  setupDynamicFields() {
    Future<DocumentSnapshot> object =
        DatabaseService.getObjectById(widget.object.id);
    setState(() {
      _dynamicObject = object;
    });
  }

  setupOwner() {
    Future<DocumentSnapshot> owner =
        DatabaseService.getCustomerById(widget.object.ownerId);
    setState(() {
      _dynamicOwner = owner;
    });
  }

  _setupDocumentCount() async {
    int documents = await DatabaseService.getDocumentsCount(widget.object.id);
    setState(() {
      _documentCount = documents;
    });
  }

  _setupImageCount() async {
    int images = await DatabaseService.getImageCount(widget.object.id);
    setState(() {
      _imageCount = images;
    });
  }

  _setupOrderCounts() {
    _setupDoneOrderCounts();
    _setupTotalOrderCounts();
  }

  _setupTotalOrderCounts() async {
    int total = await DatabaseService.getTotalOrders(widget.object.id);
    setState(() {
      _totalOrders = total;
    });
  }

  _setupDoneOrderCounts() async {
    int done = await DatabaseService.getDoneOrders(widget.object.id);
    setState(() {
      _doneOrders = done;
    });
  }

  Widget _buildActionButton(IconData icon, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: MyColors.primary, borderRadius: BorderRadius.circular(5.0)),
        child: Icon(
          icon,
          size: 18.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        backdropEnabled: true,
        controller: _pcOwner,
        borderRadius: radius,
        minHeight: 0.0,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        panel: OwnerDetails(object: widget.object, pc: _pcOwner, updateFunction: setupOwner,),
        body: SlidingUpPanel(
          backdropEnabled: true,
          controller: _pc,
          borderRadius: radius,
          minHeight: 0.0,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          panel: InOutDialog(
            updateFunction: setupDynamicFields,
            object: widget.object,
            pc: _pc,
          ),
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
                            image: CachedNetworkImageProvider(
                                widget.object.imageUrl),
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
                  child: FutureBuilder(
                      future: _dynamicObject,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text(' ');
                        }
                        StoredObject futureObject =
                            StoredObject.fromDoc(snapshot.data);
                        return Row(
                          children: <Widget>[
                            MyLayout.oneItem(
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.swap_horiz,
                                        size: 44.0, color: MyColors.primary),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        futureObject.inDate != null
                                            ? Text(
                                                'In: ${futureObject.inDate.toDate().day} ${TimeService.getMonthString(futureObject.inDate.toDate().month)} ${futureObject.inDate.toDate().year} ')
                                            : Text('Indata ej angett'),
                                        futureObject.outDate != null
                                            ? Text(
                                                'Ut: ${futureObject.outDate.toDate().day} ${TimeService.getMonthString(futureObject.outDate.toDate().month)} ${futureObject.outDate.toDate().year} ')
                                            : Text('Utdata ej angett'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(futureObject.storageType,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Icon(Icons.arrow_forward_ios,
                                            size: 14.0)
                                      ],
                                    )
                                  ],
                                ),
                                () => _pc.open()),
                            MyLayout.oneItem(
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: MyCircularProcentIndicator
                                        .buildIndicator(
                                            _doneOrders, _totalOrders),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Arbete',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Icon(Icons.arrow_forward_ios, size: 14.0)
                                    ],
                                  )
                                ],
                              ),
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WorkPage(
                                    inObjectId: futureObject.id,
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      })),
              Container(
                margin: EdgeInsets.all(8.0),
                height: 100.0,
                width: MediaQuery.of(context).size.width,
                child: Row(children: <Widget>[
                  MyLayout.oneItem(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(_imageCount.toString(),
                            style: TextStyle(
                                color: MyColors.primary,
                                fontSize: 38.0,
                                fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Bilder',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                            Icon(Icons.arrow_forward_ios, size: 13.0),
                          ],
                        ),
                      ],
                    ),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BoatImages(
                          inObjectId: widget.object.id,
                        ),
                      ),
                    ),
                  ),
                  MyLayout.oneItem(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(_documentCount.toString(),
                            style: TextStyle(
                                color: MyColors.primary,
                                fontSize: 38.0,
                                fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Dokument',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                            Icon(Icons.arrow_forward_ios, size: 13.0)
                          ],
                        ),
                      ],
                    ),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DocumentScreen(
                          inObjectId: widget.object.id,
                        ),
                      ),
                    ),
                  ),
                  MyLayout.oneItem(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(widget.object.space.toInt().toString(),
                              style: TextStyle(
                                  color: MyColors.primary,
                                  fontSize: 38.0,
                                  fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Kvm',
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold)),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13.0,
                                color: MyColors.lightBlue,
                              )
                            ],
                          ),
                        ],
                      ),
                      null),
                ]),
              ),
              widget.object.ownerId != '' && widget.object.ownerId != null
                  ? FutureBuilder(
                      future: _dynamicOwner,
                      builder: (BuildContext contex, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox.shrink();
                        }
                        Customer customer = Customer.fromDoc(snapshot.data);
                        return MyLayout.oneItemNoExpand(
                            Column(children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    customer.name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _buildActionButton(
                                          Icons.phone,
                                          () => print(
                                              'phone to ${customer.phone}')),
                                      SizedBox(width: 32.0),
                                      _buildActionButton(
                                          Icons.mail,
                                          () => print(
                                              'mail to ${customer.email}')),
                                      SizedBox(width: 16.0),
                                    ],
                                  ),
                                ],
                              )
                            ]),
                            () => _pcOwner.open());
                      })
                  : MyLayout.oneItemNoExpand(
                            Column(children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.person, color: MyColors.primary,),
                                  SizedBox(width: 10.0,),
                                  Text(
                                    'Ingen ägare tilldelad',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  
                                ],
                              )
                            ]),
                            () => _pcOwner.open()),
              MyLayout.oneItemNoExpand(
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.info,
                            color: MyColors.primary,
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                  text: 'Modell: ',
                                  children: [
                                    TextSpan(
                                        text: widget.object.model != ''
                                            ? widget.object.model
                                            : 'Ej angett',
                                        recognizer: LongPressGestureRecognizer()
                                          ..onLongPress = () => _launchInBrowser(
                                              'https://www.google.se/search?q=${widget.object.model} ${widget.object.year != null ? widget.object.year : ''}'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal))
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                  text: 'Årsmodell: ',
                                  children: [
                                    TextSpan(
                                        text: widget.object.year == null
                                            ? 'Okänt'
                                            : widget.object.year.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal))
                                  ],
                                ),
                              ),
                              widget.object.serialnumber.isEmpty
                                  ? SizedBox.shrink()
                                  : RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                        text: 'Serienummer: ',
                                        children: [
                                          TextSpan(
                                              text: widget.object.serialnumber,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                      widget.object.engine != ''
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 16.0),
                                Divider(height: 1.0),
                                SizedBox(height: 16.0),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.settings,
                                      color: MyColors.primary,
                                    ),
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                              text: 'Motor: ',
                                              children: [
                                                TextSpan(
                                                    text: widget.object.engine,
                                                    recognizer:
                                                        LongPressGestureRecognizer()
                                                          ..onLongPress = () =>
                                                              _launchInBrowser(
                                                                  'https://www.google.se/search?q=${widget.object.engine} ${widget.object.engineYear != null ? widget.object.engineYear : ' '}'),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                              text: 'Motorns årsmodell: ',
                                              children: [
                                                TextSpan(
                                                    text: widget.object
                                                                .engineYear ==
                                                            null
                                                        ? 'Okänt'
                                                        : widget
                                                            .object.engineYear
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ],
                                            ),
                                          ),
                                          widget.object.engineSerialnumber
                                                  .isEmpty
                                              ? SizedBox.shrink()
                                              : RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    text: 'Serienummer: ',
                                                    children: [
                                                      TextSpan(
                                                          text: widget.object
                                                              .engineSerialnumber,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))
                                                    ],
                                                  ),
                                                ),
                                        ]),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  null),
            ],
          ),
        ),
      ),
    );
  }
}
