import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/screens/object/widgets/my_layout_widget.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/time_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


//Builds the view shown in panel for object_screen.dart
class InOutDialog extends StatefulWidget {
  final StoredObject object; //current object
  final PanelController pc; //controller to open and close the panel in parent class
  final Function updateFunction; //Used to update the UI in parent widget when new changes occur
  InOutDialog({this.object, this.pc, this.updateFunction});

  @override
  _InOutDialogState createState() => _InOutDialogState();
}

class _InOutDialogState extends State<InOutDialog> {
  DateTime _inDate;
  DateTime _outDate;
  String _storageType = 'Hall ej angedd';
  bool _isLoading = false;

  //Picker for selecting the date for arrival
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2030));
    if (picked != null)
      setState(
        () => _inDate = picked,
      );
  }

  //Picker for selecting out date
  Future _selectOutDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2030));
    if (picked != null)
      setState(
        () => _outDate = picked,
      );
  }

  @override
  void initState() {
    super.initState();

    //If the object already has assigned dates it's given to the attributes shown in UI
    if (widget.object.inDate != null && widget.object.outDate != null) {
      setState(() {
        _inDate = widget.object.inDate.toDate();
        _outDate = widget.object.outDate.toDate();
        
      });
    }
    setState(() {
      _storageType = widget.object.storageType;
    });
  }


  _submitChanges() {
    if (!_isLoading) {
      setState((){
        _isLoading = true;
        widget.object.storageType = _storageType;
      });

      StoredObject updatedObject = StoredObject(
        id: widget.object.id,
        title: widget.object.title,
        timestamp: widget.object.timestamp,
        description: widget.object.description,
        engine: widget.object.engine,
        engineSerialnumber: widget.object.engineSerialnumber,
        model: widget.object.model,
        serialnumber: widget.object.serialnumber,
        billingSum: widget.object.billingSum,
        inDate: _inDate != null ? Timestamp.fromDate(_inDate) : null,
        outDate: _outDate != null ? Timestamp.fromDate(_outDate) : null,
        imageUrl: widget.object.imageUrl,
        storageType: _storageType,
        space: widget.object.space,
        category: widget.object.category
      );

      DatabaseService.updateObjectTotal(updatedObject);
      

      setState(() {
        _isLoading = false;
      });

      widget.pc.close(); //Close the panel
      widget.updateFunction(); //updates the UI

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => widget.pc.close()),
              Text(
                'Justera Datum',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: null)
            ]),
        Divider(height: 1.0),
        SizedBox(
          height: 16.0,
        ),
        Container(
          height: 120.0,
          child: MyLayout.oneItemNoExpand(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Inlämning',
                        style:
                            TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.edit, size: 18.0,)
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Center(
                      child: Text(
                        _inDate != null
                            ? '${_inDate.day.toString()} ${TimeService.getMonthString(_inDate.month)} ${_inDate.year}'
                            : 'Ej angett',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              _selectDate),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          height: 120.0,
          child: MyLayout.oneItemNoExpand(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Utlämning',
                        style:
                            TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.edit, size: 18.0,)
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Center(
                      child: Text(
                        _outDate != null
                            ? '${_outDate.day.toString()} ${TimeService.getMonthString(_outDate.month)} ${_outDate.year}'
                            : 'Ej angett',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              _selectOutDate),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          height: 120.0,
          child: MyLayout.oneItemNoExpand(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Placeras i',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  DropdownButton<String>(
                      value: _storageType,
                      icon: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.arrow_downward,
                            ),
                          ],
                        ),
                      ),
                      iconSize: 20,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.black38,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _storageType = newValue;
                        });
                      },
                      //Hard coded categories. Add new categories here.
                      items: <String>[
                        'Hall ej angedd',
                        'Varmhall',
                        'Kallhall',
                        'Övrigt',
                        
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                ],
              ),
              null),
        ),
        SizedBox(
          height: 30.0,
        ),
        Center(
          child:
              FlatButton(onPressed: _submitChanges, child: Text('Uppdatera')),
        ),
        SizedBox(
          height: 40.0,
        ),
      ],
    );
  }
}
