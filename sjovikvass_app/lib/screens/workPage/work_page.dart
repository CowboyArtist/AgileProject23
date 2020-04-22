import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/work_list_tile_widget.dart';

import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';



class WorkPage extends StatefulWidget {
  
  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  List<WorkOrder> workOrders = [
    WorkOrder(title: 'Jag heter jonathan', isDone: true, sum: 10.0),
    WorkOrder(title: 'Jag heter simon', isDone: false, sum: 40.0)
  ];

  double workTotalSum = 0;


  _calculateSum() { 
    double totalSum = 0;
    for(WorkOrder workOrder in workOrders){
      if(workOrder.isDone){
        totalSum += workOrder.sum;
      }
    }
    setState(() {
      workTotalSum = totalSum;
    });
  }

  @override
  void initState (){
    super.initState();

    _calculateSum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar('Arbete'),
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
                      onPressed: () => print('Hej Simon'),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text('Ny'),
                ],
              ),
              new CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 8.0,
                percent: 1.0,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 18.0,
                    ),
                    Text(
                      "100%",
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
            child: ListView.builder(
              itemCount: workOrders.length,
              itemBuilder: (BuildContext context, int index) {
                return WorkListTile(workOrder: workOrders[index],);
              },
            ),
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
                Text(workTotalSum.toString() + ' kr'),
              ],
            ),
          ),
          FlatButton(
            onPressed: () => print('Detta är för framtida utvecklingar'),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Båten är klar',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            color: Colors.black12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }
}
