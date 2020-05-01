import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/work_order_material_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/screens/workPage/design/bottom_wave_clipper.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

//The class PriceDialog is the pop-up that comes when the work order's isDone button is set to done.

class PriceDialog extends StatefulWidget {
  final WorkOrder workOrder;
  final String inObjectId;
  final ValueNotifier<int> valueNotifier;

  PriceDialog({
    this.inObjectId,
    this.workOrder,
    this.valueNotifier,
  });

  @override
  _PriceDialogState createState() => _PriceDialogState();
}

class _PriceDialogState extends State<PriceDialog> {
  Duration value;
  double hourlyRate = 120.0;
  double totalPrice = 0.0;
  double _timeAmount;

//Sets if the work order is done and update the corresponding values in database
  _toggleIsDone() {
    setState(() {
      widget.workOrder.isDone = !widget.workOrder.isDone;
    });
    WorkOrderMaterial finishedWork = WorkOrderMaterial(
        title: 'Arbetad tid', amount: _timeAmount, cost: hourlyRate);
    DatabaseService.addMaterialToWorkOrder(widget.workOrder.id, finishedWork);
    DatabaseService.updateWorkOrder(widget.inObjectId, widget.workOrder);
    if (widget.workOrder.isDone) {
      DatabaseService.updateObject(
          widget.inObjectId, widget.workOrder.sum + totalPrice);
      DatabaseService.updateWorkOrderSum(
          widget.inObjectId, widget.workOrder.id, totalPrice);
      widget.valueNotifier.value++;
    }
  }

  //Calculates the price for the work order and sets it to hours.
  _calculateHourlyPrice() {
    if (value != null) {
      setState(() {
        totalPrice = (value.inMinutes / 60) * hourlyRate;
        _timeAmount = value.inMinutes / 60;
      });
      Navigator.of(context).pop(true);
    }

    print(totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) {
    return Container(
      height: 400.0,
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
              height: 170.0,
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
                      'Är du klar med',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: MyColors.backgroundLight,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text(
                      widget.workOrder.title,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // The timer scroll for the pop-up
          Container(
            height: 160.0,
            child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                onTimerDurationChanged: (value) {
                  setState(() {
                    this.value = value;
                  });
                }),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 40.0,
            width: 200.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.green,
            ),
            child: FlatButton(
                child: Text(
                  'Markera som klar',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onPressed: () {
                  _calculateHourlyPrice();
                  _toggleIsDone();
                }),
          ),
        ],
      ),
    );
  }
}
