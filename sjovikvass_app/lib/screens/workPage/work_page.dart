import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/work_list_tile_widget.dart';
import 'package:sjovikvass_app/services/database_service.dart';

import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

import 'package:percent_indicator/percent_indicator.dart';
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

  //Boolean to determine when to turn the bottom button to green
  bool _allDone = false;

  

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
    TextEditingController workController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Lägg till arbete'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            content: Container(
              height: 200.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Beskrivning: '),
                  TextField(
                    controller: workController,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('Pris:'),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('Lägg till'),
                //Adds the object to the database and update the total amount of workorders.
                onPressed: () {
                  Navigator.of(context).pop(workController.text.toString());

                  DatabaseService.addWorkOrderToObject(
                      WorkOrder(
                          isDone: false,
                          title: workController.text,
                          sum: double.parse(priceController.text)),
                      widget.inObjectId);
                  setState(() {
                    _counterTotal.value++;
                  });
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();

    _setupPercentIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                 
                    
                    return CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 8.0,
                    percent: value / total,
                    animation: true,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 18.0,
                        ),
                        Text(
                          total == 0 ? '0 %' : "${(value/total * 100).round()}%",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: MyColors.primary),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Klart',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                    progressColor: MyColors.primary,
                  );
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
                      print(snapshot.data);
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
                    onPressed: () => print('Detta är för framtida utvecklingar'),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Båten är klar',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                    color: _counterTotal.value == _counterDone.value && _counterTotal.value != 0 ? Colors.green : Colors.black12,
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