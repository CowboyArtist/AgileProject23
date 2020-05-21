import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/contact_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

//The screen that appears when creating a contact.

class AddContact extends StatefulWidget {
  final String inSupplierId;

  AddContact({
    this.inSupplierId,
  });
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  //to avoid program crashing
  bool _contactIsLoading = false;

  //Boolean validates if the user has completed reguired input
  bool _contactValidate = false;

  //Text controllers for input

  TextEditingController _contactNameController = TextEditingController();
  String _contactName = '';

  TextEditingController _contactPhoneController = TextEditingController();
  String _contactPhone = '';

  TextEditingController _contactEmailController = TextEditingController();
  String _contactEmail = '';

  @override
  void initState() {
    super.initState();
  }

  //Method for saving contact to the database with the correct values.

  _submitStoredContact() async {
    if (!_contactIsLoading && _contactName.isNotEmpty) {
      setState(() {
        _contactIsLoading = true;
      });

      ContactModel storedContact = ContactModel(
        name: _contactName,
        phoneNumber: _contactPhone,
        email: _contactEmail,
        isMainContact: false,
      );

      _contactNameController.clear();
      _contactPhoneController.clear();
      _contactEmailController.clear();

      DatabaseService.addContactToSupplier(storedContact, widget.inSupplierId);

      setState(() {
        _contactName = '';
        _contactPhone = '';
        _contactEmail = '';
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
                children: <Widget>[
                  TextField(
                    controller: _contactNameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 15.0),
                      labelText: 'Kontakt',
                      errorText:
                          _contactValidate ? 'Kontaktnamn måste anges' : null,
                    ),
                    onChanged: (input) => _contactName = input,
                  ),
                  TextField(
                    controller: _contactPhoneController,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 15.0),
                      labelText: 'Telefon',
                    ),
                    onChanged: (input) => _contactPhone = input,
                  ),
                  TextField(
                    maxLines: null,
                    controller: _contactEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 15.0),
                      labelText: 'Email',
                    ),
                    onChanged: (input) => _contactEmail = input,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Confirmation dialog before adding object to database
  showAlertDialog(BuildContext context) {
    setState(() {
      _contactNameController.text.isEmpty
          ? _contactValidate = true
          : _contactValidate = false;
    });

    if (!_contactIsLoading && _contactName.isNotEmpty) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("Spara"),
        onPressed: () {
          _submitStoredContact();
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
        title: Text("Bekräfta Kontakt"),
        content: Text("Vill du spara ${_contactName}?"),
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
      appBar: AppBar(
        title: Text('Lägg till kontakt'),
      ),
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
              'Skapa kontakt',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
