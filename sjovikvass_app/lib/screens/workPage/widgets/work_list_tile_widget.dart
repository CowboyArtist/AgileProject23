import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/price_dialog_widget.dart';
import 'package:sjovikvass_app/services/database_service.dart';

//Defines the appearance of the list tile in the list of work_page.dart
class WorkListTile extends StatefulWidget {
  final WorkOrder workOrder;
  final String inObjectId;
  final ValueNotifier<int> valueNotifier;

  WorkListTile({this.workOrder, this.inObjectId, this.valueNotifier});

  @override
  _WorkListTileState createState() => _WorkListTileState();
}

class _WorkListTileState extends State<WorkListTile> {
  //Sets or resets if the work order is done and update the corresponding values in database
  _toggleIsDone() {
    setState(() {
      widget.workOrder.isDone = !widget.workOrder.isDone;
    });
    DatabaseService.updateWorkOrder(widget.inObjectId, widget.workOrder);
    if (widget.workOrder.isDone) {
      DatabaseService.updateObject(widget.inObjectId, widget.workOrder.sum);
      widget.valueNotifier.value++;
    } else {
      DatabaseService.updateObject(widget.inObjectId, -widget.workOrder.sum);
      widget.valueNotifier.value--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 10.0),
      decoration: BoxDecoration(
        color:
            widget.workOrder.isDone ? Colors.lightGreen[200] : Colors.black12,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.workOrder.isDone
                ? null
                : showDialog(
                    context: context,
                    builder: (context) => PriceDialog(
                          inObjectId: widget.inObjectId,
                          workOrder: widget.workOrder,
                        ));
            _toggleIsDone();
          },
          child: AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: widget.workOrder.isDone ? Colors.green : Colors.black12,
            ),
            height: 20.0,
            width: 20.0,
            duration: Duration(milliseconds: 150),
            curve: Curves.linear,
          ),
        ),
        title: Text(
          widget.workOrder.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          widget.workOrder.sum.toString() + ' kr',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
