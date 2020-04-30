import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/work_order_material_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/price_dialog_widget.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/work_order_material_list_tile_widget.dart';
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

class _WorkListTileState extends State<WorkListTile>
    with TickerProviderStateMixin {
  bool _resized = false;
  double _height = 56.0;
  double _extraheight = 0.0;

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
  void initState() {
    super.initState();
    _setupNrMaterials();
  }

  _setupNrMaterials() async {
    int nMaterials = await DatabaseService.getNrMaterials(widget.workOrder.id);
    if (nMaterials != 0) {
      setState(() {
        _extraheight = 56.0 * nMaterials;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
        duration: Duration(milliseconds: 500),
        vsync: this,
        curve: Curves.fastLinearToSlowEaseIn,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (_resized) {
                _height = 56.0;
                _resized = false;
              } else {
                _height += (_extraheight + 100.0);
                _resized = true;
              }
            });
          },
          child: Container(
            height: _height,
            margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 10.0),
            decoration: BoxDecoration(
              color: widget.workOrder.isDone
                  ? Colors.lightGreen[200]
                  : Colors.black12,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
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
                        color: widget.workOrder.isDone
                            ? Colors.green
                            : Colors.black12,
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
                _resized
                    ? Expanded(
                        child: StreamBuilder(
                            stream: DatabaseService.getWorkOrderMaterials(
                                widget.workOrder.id),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('Laddar...');
                              }

                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  WorkOrderMaterial workOrderMaterial =
                                      WorkOrderMaterial.fromDoc(
                                          snapshot.data.documents[index]);
                                  return MaterialListTile(
                                    workOrderMaterial: workOrderMaterial,
                                  );
                                },
                              );
                            }),
                      )
                    : SizedBox.shrink(),
                _resized
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              width: 70.0,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Nytt material',
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                ),
                              ),
                            ),
                          ),
                          //TextField(decoration: InputDecoration(hintText: '1'))
                        ],
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ));
  }
}
