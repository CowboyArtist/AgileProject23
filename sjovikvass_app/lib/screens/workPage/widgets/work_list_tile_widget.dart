import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sjovikvass_app/models/work_order_material_model.dart';
import 'package:sjovikvass_app/models/work_order_model.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/price_dialog_widget.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/work_order_material_list_tile_widget.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

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
  final ValueNotifier<bool> _resized = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isDone = ValueNotifier<bool>(true);
  final ValueNotifier<double> _height = ValueNotifier<double>(56.0);
  final ValueNotifier<double> _extraheight = ValueNotifier<double>(0.0);

//Controllers for the textfields
  TextEditingController materialController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupNrMaterials();
    _height.value = 56.0;

    _isDone.value = widget.workOrder.isDone;
  }

//Counts the materials for the WorkOrder.
  _setupNrMaterials() async {
    int nMaterials = await DatabaseService.getNrMaterials(widget.workOrder.id);
    if (nMaterials != 0) {
      setState(() {
        _extraheight.value = 40.0 * nMaterials;
      });
    } else {
      _extraheight.value = 0.0;
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

  _showDeleteAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      color: Colors.redAccent,
      child: Text("Radera"),
      onPressed: () {
        DatabaseService.removeWorkOrder(widget.inObjectId, widget.workOrder.id);
        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Avbryt"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Vill du ta bort ${widget.workOrder.title}?"),
      content: Text(
          "Tänk på att material kan gå förlorade. Du kan inte ångra detta i efterhand."),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
          setState(() {
            if (_resized.value) {
              _height.value = 56.0;
              _resized.value = false;
            } else {
              _resized.value = true;
            }
          });
        },
        child: ValueListenableBuilder<bool>(
            valueListenable: _resized,
            builder: (BuildContext context, bool resized, Widget child) {
              return ValueListenableBuilder<double>(
                  valueListenable: _extraheight,
                  builder:
                      (BuildContext context, double extraheight, Widget child) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            foregroundColor: Colors.red,
                            caption: 'Radera Objekt',
                            icon: Icons.delete,
                            onTap: () => _showDeleteAlertDialog(context))
                      ],
                      child: Container(
                        height: resized
                            ? _height.value + extraheight + 90.0
                            : _height.value,
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
                                          _isDone.value = !_isDone.value;
                                          DatabaseService.updateObject(
                                              widget.inObjectId,
                                              -widget.workOrder.sum,
                                              false);
                                          widget.valueNotifier.value--;
                                          DatabaseService.updateWorkOrder(
                                              widget.inObjectId,
                                              widget.workOrder);
                                          _setupNrMaterials();
                                        })
                                      //Makes the pop-up PriceDialog appear.
                                      : showDialog(
                                          context: context,
                                          builder: (context) => PriceDialog(
                                                inObjectId: widget.inObjectId,
                                                workOrder: widget.workOrder,
                                                valueNotifier:
                                                    widget.valueNotifier,
                                                isDone: _isDone,
                                                height: _height,
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
                                widget.workOrder.sum.toStringAsFixed(1) + ' kr',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            // This part builds the ListView if the work order is expanded.
                            resized
                                ? Expanded(
                                    child: StreamBuilder(
                                        stream: DatabaseService
                                            .getWorkOrderMaterials(
                                                widget.workOrder.id),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Text(' ');
                                          }

                                          return ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                snapshot.data.documents.length,
                                            itemBuilder: (context, index) {
                                              WorkOrderMaterial
                                                  workOrderMaterial =
                                                  WorkOrderMaterial.fromDoc(
                                                      snapshot.data
                                                          .documents[index]);
                                              _extraheight.value = (snapshot
                                                      .data.documents.length *
                                                  40.0);

                                              return MaterialListTile(
                                                workOrderMaterial:
                                                    workOrderMaterial,
                                                inWorkOrderId:
                                                    widget.workOrder.id,
                                                inObjectId: widget.inObjectId,
                                                parentIsDone: _isDone,
                                              );
                                            },
                                          );
                                        }),
                                  )
                                : SizedBox.shrink(),
                            /*The boxes for the "Nytt material" section which will only pop up when the
                                workorder is not done */
                            (_resized.value && !widget.workOrder.isDone)
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            height: 40,
                                            decoration:
                                                _decorateNewMaterialContainer(),
                                            child: TextField(
                                              controller: materialController,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              maxLength: 20,
                                              decoration: InputDecoration(
                                                  hintText: 'Nytt material',
                                                  border: InputBorder.none,
                                                  counterText: ""),
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
                                          decoration:
                                              _decorateNewMaterialContainer(),
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
                                          decoration:
                                              _decorateNewMaterialContainer(),
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
                                            FocusScopeNode currentFocus =
                                                FocusScope.of(context);

                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                            double _totalMaterialCost =
                                                amountController.text.isEmpty
                                                    ? double.parse(
                                                        costController.text)
                                                    : (double.parse(
                                                            costController
                                                                .text) *
                                                        double.parse(
                                                            amountController
                                                                .text));
                                            DatabaseService
                                                .addMaterialToWorkOrder(
                                              widget.workOrder.id,
                                              WorkOrderMaterial(
                                                title: materialController.text,
                                                amount: amountController
                                                        .text.isEmpty
                                                    ? 1.0
                                                    : double.parse(
                                                        amountController.text),
                                                cost: double.parse(
                                                    costController.text),
                                              ),
                                            );

                                            DatabaseService.updateWorkOrder(
                                              widget.inObjectId,
                                              WorkOrder(
                                                  id: widget.workOrder.id,
                                                  title: widget.workOrder.title,
                                                  isDone:
                                                      widget.workOrder.isDone,
                                                  sum: widget.workOrder.sum +=
                                                      _totalMaterialCost),
                                            );
                                            setState(() {
                                              widget.workOrder.sum +=
                                                  _totalMaterialCost;
                                            });
                                            _setupNrMaterials();
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
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
