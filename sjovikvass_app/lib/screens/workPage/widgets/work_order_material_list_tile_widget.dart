import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/work_order_material_model.dart';

class MaterialListTile extends StatelessWidget {
  final WorkOrderMaterial workOrderMaterial;

  MaterialListTile({this.workOrderMaterial});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(55.0, 0, 0, 4.0),
      height: 40.0,
      // color: Colors.yellow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () => print('Hej'),
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
          Text('69'),
          Row(
            children: <Widget>[
              Text(' 42000' + ' kr'),
              SizedBox(width: 16.0),
            ],
          ),
        ],
      ),
    );
  }
}
