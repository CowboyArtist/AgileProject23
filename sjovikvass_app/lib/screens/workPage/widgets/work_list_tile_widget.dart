import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';

class WorkListTile extends StatefulWidget {
  final WorkOrder workOrder;
  final String inObjectId;
  

  WorkListTile({
    this.workOrder,
    this.inObjectId,
   
  });

  @override
  _WorkListTileState createState() => _WorkListTileState();
}

class _WorkListTileState extends State<WorkListTile> {



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
          onTap: () => setState(() {
            widget.workOrder.isDone = !widget.workOrder.isDone;
            DatabaseService.updateWorkOrder(
                widget.inObjectId, widget.workOrder);
            widget.workOrder.isDone
                ? DatabaseService.updateObject(
                    widget.inObjectId, widget.workOrder.sum)
                : DatabaseService.updateObject(
                    widget.inObjectId, -widget.workOrder.sum);
          
          }),
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
