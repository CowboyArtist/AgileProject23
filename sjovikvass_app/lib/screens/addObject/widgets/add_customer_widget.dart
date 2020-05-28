import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sjovikvass_app/models/customer_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

//Screen for creating new Customers
class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  bool _nameValidate = false;
  bool _isLoading = false;

  TextEditingController _nameController = TextEditingController();
  String _name = '';
  TextEditingController _addressController = TextEditingController();
  String _address = '';
  TextEditingController _codeController = TextEditingController();
  String _postalCode = '';
  TextEditingController _cityController = TextEditingController();
  String _city = '';

  TextEditingController _phoneController = TextEditingController();
  String _phone = '';
  TextEditingController _emailController = TextEditingController();
  String _email = '';

  bool _gdpr = false;

  _submitCustomer() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      Customer customer = Customer(
          name: _name,
          address: _address,
          postalCode: _postalCode,
          city: _city,
          phone: _phone,
          email: _email,
          gdpr: _gdpr);

      _nameController.clear();
      _addressController.clear();
      _codeController.clear();
      _cityController.clear();
      _phoneController.clear();
      _emailController.clear();
      setState(() {
        _name = '';
        _address = '';
        _postalCode = '';
        _city = '';
        _phone = '';
        _email = '';
        _gdpr = false;
      });
      DatabaseService.addCustomer(customer); //Add to database
      Navigator.of(context).pop(); //Pop context and go to homepage
    }
  }

  //Confirmation dialog before adding object to database
  showAlertDialog(BuildContext context) {
    setState(() {
      _nameController.text.isEmpty
          ? _nameValidate = true
          : _nameValidate = false;
    });

    if (!_isLoading && _name.isNotEmpty) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("Spara"),
        onPressed: () {
          _submitCustomer();
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text("Bekräfta kund"),
        content: Text("Vill du spara ${_name}?"),
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
      body: SingleChildScrollView(
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
                      'Ny kund',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 15.0),
                        labelText: 'Kundens namn',
                        errorText: _nameValidate ? 'Namn måste anges' : null,
                      ),
                      onChanged: (input) => _name = input,
                    ),
                    TextField(
                      controller: _addressController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 15.0),
                        labelText: 'Adress',
                      ),
                      onChanged: (input) => _address = input,
                    ),
                    TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 15.0),
                        labelText: 'Postkod',
                      ),
                      onChanged: (input) => _postalCode = input,
                    ),
                    TextField(
                      controller: _cityController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 15.0),
                        labelText: 'Stad',
                      ),
                      onChanged: (input) => _city = input,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.0),
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
                      'Kontaktuppgifter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 15.0),
                        labelText: 'Telefonnummer',
                      ),
                      onChanged: (input) => _phone = input,
                    ),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 15.0),
                        labelText: 'E-postadress',
                      ),
                      onChanged: (input) => _email = input,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.0),
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
                      'GDPR',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(children: <Widget>[
                      Checkbox(
                          value: _gdpr,
                          onChanged: (value) {
                            setState(() {
                              _gdpr = value;
                            });
                          }),
                      Flexible(
                          child: Text(
                        'Jag har meddelat kunden att jag sparar dennes uppgifter.',
                        overflow: TextOverflow.fade,
                      ))
                    ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
              'Skapa kund',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
