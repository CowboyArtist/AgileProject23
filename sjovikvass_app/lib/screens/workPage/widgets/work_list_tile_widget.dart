import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/work_order_material_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/price_dialog_widget.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/work_order_material_list_tile_widget.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

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
  final ValueNotifier<double> _height = ValueNotifier<double>(56.0);
  double _extraheight = 0.0;

  TextEditingController materialController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupNrMaterials();
    _height.value = 56.0;
  }

  //Gets the amount of materials for a workorder and adjusts the height accordingly.
  _setupNrMaterials() async {
    int nMaterials = await DatabaseService.getNrMaterials(widget.workOrder.id);
    if (nMaterials != 0) {
      setState(() {
        _extraheight = 40.0 * nMaterials;
      });
    }
  }

  //Decorates the boxes for the textfields in the "Nytt material" section
  _decorateNewMaterialContainer() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.grey,
      border: Border.all(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
        alignment: Alignment.topCenter,
        duration: Duration(milliseconds: 500),
        vsync: this,
        curve: Curves.fastLinearToSlowEaseIn,
        child: GestureDetector(
          onTap: () {
            //This is the setState to reveal more information about the work order.
            setState(() {
              if (_resized) {
                _height.value = 56.0;
                _resized = false;
              } else {
                _height.value += (_extraheight + 100.0);
                _resized = true;
              }
            });
          },
          child: ValueListenableBuilder<double>(
              valueListenable: _height,
              builder: (BuildContext context, double height, Widget child) {
                return Container(
                  height: height,
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
                                /*This setState sets the done button to not done and subtracts the cost of this work order
                            from the total price*/
                                ? setState(() {
                                    widget.workOrder.isDone =
                                        !widget.workOrder.isDone;
                                    DatabaseService.updateObject(
                                        widget.inObjectId,
                                        -widget.workOrder.sum);
                                    widget.valueNotifier.value--;
                                    DatabaseService.updateWorkOrder(
                                        widget.inObjectId, widget.workOrder);
                                  })
                                //If the isDone button is not done, it makes the PriceDialog pop up.
                                : showDialog(
                                    context: context,
                                    builder: (context) => PriceDialog(
                                          inObjectId: widget.inObjectId,
                                          workOrder: widget.workOrder,
                                          valueNotifier: widget.valueNotifier,
                                        ));
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
                      // This part builds the ListView if the work order is expanded.
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
                                          inWorkOrderId: widget.workOrder.id,
                                          inObjectId: widget.inObjectId,
                                          height: _height,
                                        );
                                      },
                                    );
                                  }),
                            )
                          : SizedBox.shrink(),
                      //This part build the "Nytt material" section when the work order is expanded.
                      _resized
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      height: 40,
                                      decoration:
                                          _decorateNewMaterialContainer(),
                                      child: TextField(
                                        controller: materialController,
                                        decoration: InputDecoration(
                                          hintText: 'Nytt material',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    width: 70,
                                    height: 40,
                                    decoration: _decorateNewMaterialContainer(),
                                    child: TextField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '1',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    width: 70,
                                    height: 40,
                                    decoration: _decorateNewMaterialContainer(),
                                    child: TextField(
                                      controller: costController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'kr/st',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      double _totalMaterialCost = (double.parse(
                                              costController.text) *
                                          double.parse(amountController.text));
                                      DatabaseService.addMaterialToWorkOrder(
                                        widget.workOrder.id,
                                        WorkOrderMaterial(
                                          title: materialController.text,
                                          amount: amountController.text.isEmpty
                                              ? 1.0
                                              : double.parse(
                                                  amountController.text),
                                          cost:
                                              double.parse(costController.text),
                                        ),
                                      );

                                      DatabaseService.updateWorkOrder(
                                        widget.inObjectId,
                                        WorkOrder(
                                            id: widget.workOrder.id,
                                            title: widget.workOrder.title,
                                            isDone: widget.workOrder.isDone,
                                            sum: widget.workOrder.sum +=
                                                _totalMaterialCost),
                                      );
                                      setState(() {
                                        _height.value += 40.0;
                                        widget.workOrder.sum +=
                                            _totalMaterialCost;
                                      });
                                      materialController.clear();
                                      amountController.clear();
                                      costController.clear();
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        color: MyColors.primary,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                );
              }),
        ));
  }
}
