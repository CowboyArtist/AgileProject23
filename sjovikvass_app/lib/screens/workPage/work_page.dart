import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:sjovikvass_app/models/archive_model.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/screens/workPage/design/bottom_wave_clipper.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/work_list_tile_widget.dart';


import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/circular_indicator.dart';

import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:sjovikvass_app/utils/constants.dart';

//The screen for checklist of work orders
class WorkPage extends StatefulWidget {
  final String inObjectId;

  WorkPage({
    this.inObjectId,
  });

  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  //ValueNotifier is used to be able to change the value from another widget in the widget-tree.
  //Passed as an argument when creating WorkListTile.
  final ValueNotifier<int> _counterDone = ValueNotifier<int>(0);
  final ValueNotifier<int> _counterTotal = ValueNotifier<int>(0);

  final _formKey = GlobalKey<FormState>();
  //Boolean to determine when to turn the bottom button to green
  

  TextEditingController workController = TextEditingController();

  _setupTotalOrders() async {
    int totalOrders = await DatabaseService.getTotalOrders(widget.inObjectId);

    setState(() {
      _counterTotal.value = totalOrders;
    });
  }

  _setupDoneOrders() async {
    int doneOrders = await DatabaseService.getDoneOrders(widget.inObjectId);

    setState(() {
      _counterDone.value = doneOrders;
    });
  }

  _setupPercentIndicator() {
    _setupTotalOrders();
    _setupDoneOrders();
  }

  _createWorkOrderDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: _buildChild(context),
          );
        });
  }

  _addWorkOrderToObject() {
    Navigator.of(context).pop(workController.text.toString());
    DatabaseService.addWorkOrderToObject(
        WorkOrder(isDone: false, title: workController.text, sum: 0.0),
        widget.inObjectId);
    setState(() {
      _counterTotal.value++;
    });
  }

  _buildChild(BuildContext context) {
    return Container(
      height: 320.0,
      width: 350.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: MyColors.backgroundLight,
      ),
      child: Column(
        children: <Widget>[
          ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              width: 350.0,
              height: 140.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: MyColors.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 40, 20, 10),
                    child: Text(
                      'Lägg till en arbete',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Beskrivning',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Ange beskrivning';
                          }
                          return null;
                        },
                        controller: workController,
                        maxLines: null,
                        maxLength: 30,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Container(
                          height: 40.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.green,
                          ),
                          child: FlatButton(
                              child: Text(
                                'Lägg till',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _addWorkOrderToObject();
                                  workController.clear();
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //The dialog after the "Arkivera" button is pressed.
  _selectSeason(BuildContext context) {
    Picker(
        confirmText: 'Bekräfta',
        cancelText: 'Avbryt',
        adapter:PickerDataAdapter(data: [
          PickerItem(text: Text('Vintern'),  children: [PickerItem(text: Text((DateTime.now().year - 1).toString() + '-'+ (DateTime.now().year ).toString())),]),
          PickerItem(text: Text('Sommaren'),  children: [PickerItem(text: Text(DateTime.now().year.toString())),]),
          
        ]),
        hideHeader: true,
        title: Text("Välj säsong"),
        onConfirm: (Picker picker, List value) {
          String season;
          if (value[0] != 1) { //Because it works
            season = 'Vintern ${(DateTime.now().year - 1).toString()}-${(DateTime.now().year ).toString()}';
          } else {
            season = 'Sommaren ${(DateTime.now().year ).toString()}';
          }
          print(season);
          DatabaseService.addArchiveObject(season, widget.inObjectId);
          setState(() {
            _counterDone.value = 0;
            _counterTotal.value = 0;
          });
        }).showDialog(context);
  }

  @override
  void initState() {
    super.initState();

    _setupPercentIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DetailAppBar.buildAppBar('Arbete', context),
      body: Column(
        children: <Widget>[
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 25.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 6.0,
                            offset: Offset(3, 3),
                            color: Colors.black26)
                      ],
                      color: MyColors.lightBlue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: IconButton(
                      iconSize: 30.0,
                      color: MyColors.primary,
                      icon: Icon(Icons.add),
                      onPressed: () => _createWorkOrderDialog(context),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text('Ny'),
                ],
              ),
              //Listens to changes of _counterTotal and rebuilds child widget
              ValueListenableBuilder(
                builder: (BuildContext context, int total, Widget child) {
                  //Listens to changes of _counterDone and rebuilds child widget
                  return ValueListenableBuilder(
                    builder: (BuildContext context, int value, Widget child) {
                      return MyCircularProcentIndicator.buildIndicator(_counterDone.value, _counterTotal.value);
                    },
                    valueListenable: _counterDone,
                  );
                },
                valueListenable: _counterTotal,
              ),
              SizedBox(
                width: 34.0,
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Klar',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      'Arbete',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Text(
                  'Summa',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child:
                //Stream that updates the UI when values in database changes.
                StreamBuilder(
                    stream: DatabaseService.getWorkOrders(widget.inObjectId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Hämtar data');
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          WorkOrder workOrder =
                              WorkOrder.fromDoc(snapshot.data.documents[index]);

                          return WorkListTile(
                            inObjectId: widget.inObjectId,
                            workOrder: workOrder,
                            valueNotifier: _counterDone,
                          );
                        },
                      );
                    }),
          ),
          Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Att fakturera:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 100.0,
                  child: StreamBuilder(
                    stream: objectsRef.document(widget.inObjectId).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Hämtar data');
                      }
                      StoredObject storedObject =
                          StoredObject.fromDoc(snapshot.data);
                      return Text(storedObject.billingSum.toString() + ' kr');
                    },
                  ),
                ),
              ],
            ),
          ),
          //Listens to changes of _counterDone and rebuilds child widget
          ValueListenableBuilder(
            builder: (BuildContext context, int done, Widget child) {
              //Listens to changes of _counterTotal and rebuilds child widget
              return ValueListenableBuilder(
                builder: (BuildContext context, int total, Widget child) {
                  return FlatButton(
                    onPressed: _counterTotal.value == _counterDone.value &&
                            _counterTotal.value != 0
                        ? () =>
                        _selectSeason(context) : null,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Arkivera',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                    color: _counterTotal.value == _counterDone.value &&
                            _counterTotal.value != 0
                        ? Colors.green
                        : Colors.black12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  );
                },
                valueListenable: _counterTotal,
              );
            },
            valueListenable: _counterDone,
          ),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }
}
