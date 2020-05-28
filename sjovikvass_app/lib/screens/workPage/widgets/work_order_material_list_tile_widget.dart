import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/work_order_material_model.dart';

import 'package:sjovikvass_app/services/database_service.dart';

//This is the class that builds the tiles for the ListView in a WorkOrder.
class MaterialListTile extends StatelessWidget {
  final WorkOrderMaterial workOrderMaterial;
  final String inWorkOrderId;
  final String inObjectId;

  final ValueNotifier<bool> parentIsDone;

  MaterialListTile(
      {this.workOrderMaterial,
      this.inWorkOrderId,
      this.inObjectId,
      this.parentIsDone});

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
              ValueListenableBuilder<bool>(
                  valueListenable: parentIsDone,
                  builder:
                      (BuildContext context, bool disableButton, Widget child) {
                    return disableButton
                        ? SizedBox.shrink()
                        : IconButton(
                            onPressed: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }

                              /*The total price for the cost of the material calculating the amount 
                    of objects times the price for one*/
                              double _totalMaterialCost =
                                  (workOrderMaterial.amount *
                                      workOrderMaterial.cost);
                              DatabaseService.removeMaterialToWorkOrder(
                                  inWorkOrderId, workOrderMaterial);
                              DatabaseService.updateWorkOrderSum(inObjectId,
                                  inWorkOrderId, -_totalMaterialCost);
                            },
                            icon: Icon(
                              Icons.remove_circle_outline,
                              size: 20.0,
                            ),
                          );
                  }),
              Text(
                workOrderMaterial.title,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(workOrderMaterial.amount.toStringAsFixed(1)),
          Row(
            children: <Widget>[
              Text((workOrderMaterial.cost * workOrderMaterial.amount)
                      .toStringAsFixed(1) +
                  ' kr'),
              SizedBox(width: 16.0),
            ],
          ),
        ],
      ),
    );
  }
}
