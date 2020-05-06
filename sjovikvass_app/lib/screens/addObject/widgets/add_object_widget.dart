import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:sjovikvass_app/services/handle_image_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/storage_service.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/utils/constants.dart';

class AddObjectWidget extends StatefulWidget {
  final TabController tabController;
  AddObjectWidget({this.tabController});
  @override
  _AddObjectWidgetState createState() => _AddObjectWidgetState();
}

class _AddObjectWidgetState extends State<AddObjectWidget> {
  bool _objectIsLoading = false;
  File _image;
  bool _objectValidate = false;
  int _space = 0;

  String _category = 'Okategoriserad';
  String _imageUrl = '';

  TextEditingController _titleController = TextEditingController();
  String _title = '';

  TextEditingController _descriptionController = TextEditingController();
  String _description = '';

  TextEditingController _modelController = TextEditingController();
  String _model = '';

  int _year;
  int _engineYear;

  TextEditingController _serialController = TextEditingController();
  String _serialNumber = '';

  TextEditingController _engineController = TextEditingController();
  String _engine = '';

  TextEditingController _engineSerialController = TextEditingController();
  String _engineSerialNumber = '';

  List<DropdownMenuItem<String>> _customers = [];

  String _selectedCustomer = '';
  String _selectedCustomerId;

  @override
  void initState() {
    super.initState();
    _setupCustomerList();
  }

  _setupCustomerList() async {
    DropdownMenuItem<String> dropdownMenuItem;
    customerRef.getDocuments().then((value) => {
          value.documents.forEach((element) {
            dropdownMenuItem = DropdownMenuItem(
              child: Text(
                element['name'],
                style: TextStyle(fontSize: 15.0),
              ),
              value: '${element['name']}/${element.documentID}',
            );
            _customers.add(dropdownMenuItem);
          })
        });
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      setState(() {
        _image = imageFile;
      });
    }
  }

  //Creates object, adds it to the database and resets all values.
  _submitStoredObject() async {
    if (!_objectIsLoading && _title.isNotEmpty) {
      setState(() {
        _objectIsLoading = true;
      });

      if (_image != null) {
        _imageUrl = await StorageService.uploadObjectMainImage(_image);
      } else {
        _imageUrl = null;
      }

      if (_selectedCustomer.isNotEmpty) {
        List<String> helperList = _selectedCustomer.split('/');
        _selectedCustomerId = helperList[1];
      }

      StoredObject storedObject = StoredObject(
          title: _title,
          description: _description,
          category: _category,
          space: _space.toDouble(),
          model: _model,
          year: _year,
          serialnumber: _serialNumber,
          engine: _engine,
          engineSerialnumber: _engineSerialNumber,
          engineYear: _engineYear,
          imageUrl: _imageUrl,
          ownerId: _selectedCustomerId);

      _titleController.clear();
      _descriptionController.clear();
      _engineSerialController.clear();
      _engineController.clear();
      _modelController.clear();
      _serialController.clear();

      setState(() {
        _category = 'Okategoriserad';
      });

      DatabaseService.addObjectToDB(storedObject);

      setState(() {
        _title = '';
        _description = '';
        _model = '';
        _engine = '';
        _imageUrl = '';
        _serialNumber = '';
        _engineSerialNumber = '';
        _space = 0;
        _objectIsLoading = false;
        _image = null;
        _year = null;
        _engineYear = null;
      });
      Navigator.of(context).pop();
    }
  }

  //Shows dynamic fields for categories with engine
  _buildFieldsForEngine() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(3, 3), blurRadius: 5.0)
          ],
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Specificera Motor',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _engineController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 15.0),
                labelText: 'Motorns modell',
              ),
              onChanged: (input) => _engine = input,
            ),
            TextField(
              controller: _engineSerialController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 15.0),
                labelText: 'Motorns serienummer',
              ),
              onChanged: (input) => _engineSerialNumber = input,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Text(
                  'Årsmodell:',
                  style: TextStyle(fontSize: 15.0),
                ),
                SizedBox(
                  width: 5.0,
                ),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.black12,
                    onPressed: () => _selectYearModel(context, true),
                    child: Text(_engineYear == null
                        ? 'ej angett'
                        : _engineYear.toString()))
              ],
            ),
          ]),
    );
  }

  //Shows dynamic fields if category is not 'okategoriserad'
  _buildDynamicFields(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(3, 3), blurRadius: 5.0)
          ],
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Specificera modell',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _modelController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 15.0),
              labelText: 'Objektets modell',
            ),
            onChanged: (input) => _model = input,
          ),
          TextField(
            controller: _serialController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 15.0),
              labelText: 'Objektets Serienummer',
            ),
            onChanged: (input) => _serialNumber = input,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Text(
                'Årsmodell:',
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(
                width: 5.0,
              ),
              FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.black12,
                  onPressed: () => _selectYearModel(context, false),
                  child: Text(_year == null ? 'ej angett' : _year.toString()))
            ],
          ),
        ],
      ),
    );
  }

  _selectYearModel(BuildContext context, bool engine) {
    Picker(
        confirmText: 'Bekräfta',
        cancelText: 'Avbryt',
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 1919, end: 2025, initValue: 2020),
        ]),
        hideHeader: true,
        title: Text("Objektets årsmodell"),
        onConfirm: (Picker picker, List value) {
          setState(() {
            engine
                ? _engineYear = picker.getSelectedValues().first
                : _year = picker.getSelectedValues().first;
          });
        }).showDialog(context);
  }

  //Dialog to select space that the object takes.
  showPickerNumber(BuildContext context) {
    new Picker(
        confirmText: 'Bekräfta',
        cancelText: 'Avbryt',
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 1, end: 15),
          NumberPickerColumn(begin: 1, end: 15),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Text('X'),
          ))
        ],
        hideHeader: true,
        title: Text("Längd X Bredd"),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            _space = picker.getSelectedValues().first *
                picker.getSelectedValues()[1];
          });
        }).showDialog(context);
  }

  //Confirmation dialog before adding object to database
  showAlertDialog(BuildContext context) {
    setState(() {
      _titleController.text.isEmpty
          ? _objectValidate = true
          : _objectValidate = false;
    });

    if (!_objectIsLoading && _title.isNotEmpty) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("Spara"),
        onPressed: () {
          _submitStoredObject();
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
        title: Text("Bekräfta objekt"),
        content: Text("Vill du spara ${_title}?"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _objectIsLoading
          ? Center(
              child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(children: <Widget>[
                  GestureDetector(
                    onTap: () => ImageService.showSelectImageDialog(
                        context, _handleImage),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10.0)),
                      height: 150.0,
                      width: double.infinity,
                      child: Center(
                        child: _image == null
                            ? Icon(
                                Icons.add_a_photo,
                                size: 32.0,
                                color: Colors.black45,
                              )
                            : Container(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    image: FileImage(_image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(3, 3),
                              blurRadius: 5.0)
                        ],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Nytt Objekt',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: _titleController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 15.0),
                            labelText: 'Titel på objekt',
                            errorText:
                                _objectValidate ? 'Titel måste anges' : null,
                          ),
                          onChanged: (input) => _title = input,
                        ),
                        TextField(
                          controller: _descriptionController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 15.0),
                            labelText: 'Beskrivning',
                          ),
                          onChanged: (input) => _description = input,
                        ),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Yta:  ',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: Colors.black12,
                                    onPressed: () => showPickerNumber(context),
                                    child: Text(
                                      '${_space} kvm',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
                    width: double.infinity,
                    height: 140.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(3, 3),
                              blurRadius: 5.0)
                        ],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Ägare',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () => widget.tabController.animateTo(1),
                              child: Container(
                                padding: EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: MyColors.lightBlue),
                                child: Icon(
                                  Icons.add,
                                  color: MyColors.primary,
                                ),
                              ),
                            )
                          ],
                        ),
                        SearchableDropdown.single(
                          closeButton: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.tabController.animateTo(1);
                                  },
                                  child: Text('Lägg till ny')),
                              FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Stäng')),
                            ],
                          ),
                          items: _customers,
                          value: _selectedCustomer,
                          hint: Text(
                            "Välj kund",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          searchHint: null,
                          onChanged: (value) {
                            setState(() {
                              _selectedCustomer = value;
                            });
                          },
                          isExpanded: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(3, 3),
                                blurRadius: 5.0)
                          ],
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Objektets Kategori',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<String>(
                            value: _category,
                            icon: Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.arrow_drop_down,
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
                                _category = newValue;
                              });
                            },
                            //Hard coded categories. Add new categories here.
                            items: <String>[
                              'Okategoriserad',
                              'Båt',
                              'Vattenskoter',
                              'Vagnar',
                              'Husvagn',
                              'Övrigt'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      )),

                  SizedBox(height: 16.0),
                  //Decides which dynamic fileds that will run.
                  _category == 'Okategoriserad'
                      ? SizedBox.shrink()
                      : _buildDynamicFields(context),
                  SizedBox(height: 16.0),
                  _category == 'Båt' || _category == 'Vattenskoter'
                      ? _buildFieldsForEngine()
                      : SizedBox.shrink(),
                ]),
              ),
            ),
      bottomNavigationBar: GestureDetector(
        //Need to dynamically change what to upload (object/supplier). Implement in sprint 2
        onTap: () => showAlertDialog(context),
        child: Container(
          margin: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 40.0),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
              color: MyColors.primary,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(3, 3),
                    blurRadius: 5.0)
              ],
              borderRadius: BorderRadius.circular(10.0)),
          child: Center(
            child: Text(
              'Skapa objekt',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
