import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/handle_image_service.dart';
import 'package:sjovikvass_app/services/storage_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';


//Screen for adding objects to the database with corresponding attributes.
class AddObjectScreen extends StatefulWidget {
  @override
  _AddObjectScreenState createState() => _AddObjectScreenState();
}

class _AddObjectScreenState extends State<AddObjectScreen> {


  TextEditingController _titleController = TextEditingController();
  String _title = '';

  TextEditingController _descriptionController = TextEditingController();
  String _description = '';

  TextEditingController _modelController = TextEditingController();
  String _model = '';

  TextEditingController _serialController = TextEditingController();
  String _serialNumber = '';

  TextEditingController _engineController = TextEditingController();
  String _engine = '';

  TextEditingController _engineSerialController = TextEditingController();
  String _engineSerialNumber = '';

  String _imageUrl = '';
  File _image;

  int _space = 0;

  String _category = 'Okategoriserad';

  bool _isLoading = false;

  //Boolean validates if the user has completed reguired input
  bool _validate = false;

  //Creates object, adds it to the database and resets all values.
  _submitStoredObject() async {
    if (!_isLoading && _title.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      
      if (_image != null) {
        _imageUrl = await StorageService.uploadObjectMainImage(_image);
      }
      else {
        _imageUrl = null;
      }
      

      StoredObject storedObject = StoredObject(
          title: _title,
          description: _description,
          category: _category,
          space: _space.toDouble(),
          model: _model,
          serialnumber: _serialNumber,
          engine: _engine,
          engineSerialnumber: _engineSerialNumber,
          imageUrl: _imageUrl);
     

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
        _isLoading = false;
        _image = null;
      });
      Navigator.of(context).pop();
    }
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      
      setState(() {
        //_imageUrl = imageUrl;
        _image = imageFile;
      });
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
      child: Column(children: <Widget>[
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
      ]),
    );
  }

  //Shows dynamic fields if category is not 'okategoriserad'
  _buildDynamicFields() {
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
        children: <Widget>[
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
        ],
      ),
    );
  }

  //Confirmation dialog before adding object to database
  showAlertDialog(BuildContext context) {
    setState(() {
      _titleController.text.isEmpty ? _validate = true : _validate = false;
    });

    if (!_isLoading && _title.isNotEmpty) {
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

  //Dialog to select space that the object takes.
  showPickerNumber(BuildContext context) {
    new Picker(
        confirmText: 'Bekräfta',
        cancelText: 'Avbryt',
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 999),
        ]),
        hideHeader: true,
        title: Text("Yta i kvm"),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            _space = picker.getSelectedValues().first;
          });
        }).showDialog(context);
  }

  //Builds all fundamental fields for all objects
  _buildNewObjectView(BuildContext context) {
    return _isLoading
        ? Center(child: Container(
          width: 50.0,
          height: 50.0,
          child: CircularProgressIndicator()))
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                GestureDetector(
                  onTap: () => ImageService.showSelectImageDialog(context, _handleImage),
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
                    children: <Widget>[
                      TextField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 15.0),
                          labelText: 'Titel på objekt',
                          errorText: _validate ? 'Titel måste anges' : null,
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
                                GestureDetector(
                                  onTap: () => showPickerNumber(context),
                                                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(5.0)),
                                    child: Text(
                                      '${_space} kvm',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: MyColors.lightBlue,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: IconButton(
                                  highlightColor: MyColors.primary,
                                  color: MyColors.primary,
                                  icon: Icon(Icons.edit, size: 18.0),
                                  onPressed: () => showPickerNumber(context)),
                            )
                          ],
                        ),
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
                    child: DropdownButton<String>(
                      value: _category,
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
                    )),
                SizedBox(height: 16.0),
                //Decides which dynamic fileds that will run.
                _category == 'Okategoriserad'
                    ? SizedBox.shrink()
                    : _buildDynamicFields(),
                SizedBox(height: 16.0),
                _category == 'Båt' || _category == 'Vattenskoter'
                    ? _buildFieldsForEngine()
                    : SizedBox.shrink(),
              ]),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lägg till'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'Nytt Objekt',
              ),
              Tab(
                text: 'Ny Leverantör',
              ),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: TabBarView(children: <Widget>[
            //Builds the view for creating new objects
            _buildNewObjectView(context),

            //Builds the view for creating new supplier (to be implemented (sprint 2))
            Center(
              child: Text('Lägg till Leverantör'),
            ),
          ]),
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
              ))),
        ),
      ),
    );
  }
}
