import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

class AddSupplierWidget extends StatefulWidget {
  @override
  _AddSupplierWidgetState createState() => _AddSupplierWidgetState();
}

class _AddSupplierWidgetState extends State<AddSupplierWidget> {
  bool _supplierIsLoading = false;

  //Boolean validates if the user has completed reguired input
  bool _supplierValidate = false;

  TextEditingController _supplierNameController = TextEditingController();
  String _supplierName = '';

  TextEditingController _supplierDescriptionController =
      TextEditingController();
  String _supplierDescription = '';

  TextEditingController _supplierPhoneController = TextEditingController();
  String _supplierPhone = '';

  TextEditingController _supplierEmailController = TextEditingController();
  String _supplierEmail = '';

  _submitStoredSupplier() async {
    if (!_supplierIsLoading && _supplierName.isNotEmpty) {
      setState(() {
        _supplierIsLoading = true;
      });

      Supplier storedSupplier = Supplier(
        companyName: _supplierName,
        description: _supplierDescription,
        phoneNr: _supplierPhone,
        email: _supplierEmail,
      );

      _supplierNameController.clear();
      _supplierDescriptionController.clear();
      _supplierPhoneController.clear();
      _supplierEmailController.clear();

      DatabaseService.addSupplierToDB(storedSupplier);

      setState(() {
        _supplierName = '';
        _supplierDescription = '';
        _supplierPhone = '';
        _supplierEmail = '';
      });
      Navigator.of(context).pop();
    }
  }

  _buildNewSupplierView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
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
                    'Ny Leverantör',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _supplierNameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 15.0),
                      labelText: 'Leverantör',
                      errorText:
                          _supplierValidate ? 'Leverantör måste anges' : null,
                    ),
                    onChanged: (input) => _supplierName = input,
                  ),
                  TextField(
                    maxLines: null,
                    controller: _supplierDescriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 15.0),
                      labelText: 'Beskrivning',
                    ),
                    onChanged: (input) => _supplierDescription = input,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
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
                        'Primär Kontakt',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: _supplierPhoneController,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 15.0),
                          labelText: 'Telefon',
                        ),
                        onChanged: (input) => _supplierPhone = input,
                      ),
                      TextField(
                        maxLines: null,
                        controller: _supplierEmailController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 15.0),
                          labelText: 'Email',
                        ),
                        onChanged: (input) => _supplierEmail = input,
                      ),
                    ])),
          ],
        ),
      ),
    );
  }

  //Confirmation dialog before adding object to database
  showAlertDialog(BuildContext context) {
    setState(() {
      _supplierNameController.text.isEmpty
          ? _supplierValidate = true
          : _supplierValidate = false;
    });

    if (!_supplierIsLoading && _supplierName.isNotEmpty) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("Spara"),
        onPressed: () {
          _submitStoredSupplier();
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
        title: Text("Bekräfta Leverantör"),
        content: Text("Vill du spara ${_supplierName}?"),
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
      body: _buildNewSupplierView(),
      bottomNavigationBar: GestureDetector(
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
              'Skapa leverantör',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
