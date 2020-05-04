import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/work_order_material_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';

//This is the class that builds the tiles for the ListView in a WorkOrder.
class MaterialListTile extends StatelessWidget {
  final WorkOrderMaterial workOrderMaterial;
  final String inWorkOrderId;
  final String inObjectId;
  final ValueNotifier<double> height;

  MaterialListTile(
      {this.workOrderMaterial,
      this.inWorkOrderId,
      this.height,
      this.inObjectId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(55.0, 0, 0, 4.0),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  /*The total price for the cost of the material calculating the amount 
                  of objects times the price for one*/
                  double _totalMaterialCost =
                      (workOrderMaterial.amount * workOrderMaterial.cost);
                  DatabaseService.removeMaterialToWorkOrder(
                      inWorkOrderId, workOrderMaterial);
                  height.value -= 40.0;
                  DatabaseService.updateWorkOrderSum(
                      inObjectId, inWorkOrderId, -_totalMaterialCost);
                },
                icon: Icon(
                  Icons.remove_circle_outline,
                  size: 20.0,
                ),
              ),
              Text(
                workOrderMaterial.title,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(workOrderMaterial.amount.toString()),
          Row(
            children: <Widget>[
              Text((workOrderMaterial.cost * workOrderMaterial.amount)
                      .toString() +
                  ' kr'),
              SizedBox(width: 16.0),
            ],
          ),
        ],
      ),
    );
  }
}
