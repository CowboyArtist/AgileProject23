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
  final ValueNotifier<bool> isDone;
  final ValueNotifier<double> height;

  PriceDialog({
    this.inObjectId,
    this.workOrder,
    this.valueNotifier,
    this.isDone,
    this.height,
  });

  @override
  _PriceDialogState createState() => _PriceDialogState();
}

class _PriceDialogState extends State<PriceDialog> {
  Duration value;
  double hourlyRate = 0.0;
  double totalPrice = 0.0;
  double _timeAmount;

  TextEditingController hoursField = TextEditingController();
  final _formKey = GlobalKey<FormState>();
//Sets if the work order is done and update the corresponding values in database
  _toggleIsDone() {
    setState(() {
      widget.workOrder.isDone = !widget.workOrder.isDone;
      widget.isDone.value = !widget.isDone.value;
    });
    WorkOrderMaterial finishedWork = WorkOrderMaterial(
        title: 'Arbetad tid',
        amount: _timeAmount,
        cost: double.parse(hoursField.text));
    DatabaseService.addMaterialToWorkOrder(widget.workOrder.id, finishedWork);
    DatabaseService.updateWorkOrder(widget.inObjectId, widget.workOrder);

    if (widget.workOrder.isDone) {
      DatabaseService.updateObject(
          widget.inObjectId, widget.workOrder.sum + totalPrice, false);
      widget.valueNotifier.value++;
      DatabaseService.updateWorkOrderSum(
          widget.inObjectId, widget.workOrder.id, totalPrice);
    }
  }

  //Calculates the price for the work order and sets it to hours.
  _calculateHourlyPrice() {
    if (value != null) {
      setState(() {
        totalPrice = (value.inMinutes / 60) * double.parse(hoursField.text);
        _timeAmount = value.inMinutes / 60;
      });
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
      height: 430.0,
      width: 350.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
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
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text(
                      'Är du klar med',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      widget.workOrder.title + '?',
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

          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              children: <Widget>[
                Text(
                  'Timpris: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Form(
                  key: _formKey,
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      child: TextFormField(
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Ange timpris';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.sentences,
                        controller: hoursField,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'kr',
                            contentPadding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                            isDense: true),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                )
              ],
            ),
          ),

          // The timer scroll for the pop-up
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
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
                      if (value == null) {
                        Navigator.pop(context);
                      } else {
                        if (_formKey.currentState.validate()) {
                          _calculateHourlyPrice();
                          _toggleIsDone();
                          Navigator.pop(context);
                          //  widget.height.value -= 90;
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
