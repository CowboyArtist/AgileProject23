import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:sjovikvass_app/models/customer_model.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/screens/object/widgets/my_layout_widget.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:sjovikvass_app/utils/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

//Builds the view in Sliding up panel in objects_screen.dart
//Shows details of the owner of the object
class OwnerDetails extends StatefulWidget {
  final PanelController pc; //Used to open and close panel in parent widget
  final StoredObject object; //Selected object
  final Function updateFunction; //Calls a function in parent widget to rebuild owner of object
  OwnerDetails({this.pc, this.object, this.updateFunction});
  @override
  _OwnerDetailsState createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  List<DropdownMenuItem<String>> _customers = [];

  var _selectedCustomer;
  String _selectedCustomerId;

  bool _hasOwner = false;
  Customer _currentCustomer;

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _address = '';
  String _postalCode = '';
  String _city = '';
  String _phone = '';
  String _email = '';
  bool _gdpr = false;

  @override
  void initState() {
    super.initState();
    _setupCustomerList();
    setState(() {
      _hasOwner = widget.object.ownerId != null;
    });
  }
  //Populate the list of customer with name+id as value
  _setupCustomerList() {
    DropdownMenuItem<String> dropdownMenuItem;
    customerRef.getDocuments().then((value) => {
          value.documents.forEach((element) {
            dropdownMenuItem = DropdownMenuItem(
              child: Text(
                element['name'], //Displays the name in the UI
                style: TextStyle(fontSize: 15.0),
              ),
              value: '${element['name']}/${element.documentID}',//Name is used to make the customer searchable
            );
            _customers.add(dropdownMenuItem);
          })
        });
  }

  _submitUpdatedOwner() {
    if (_selectedCustomer.isNotEmpty) {
      List<String> helperList = _selectedCustomer.split('/'); //Helper list used to divide the selected string
      _selectedCustomerId = helperList[1]; //Selects the second part of String, which is the id of the customer
      setState(() {
        widget.object.ownerId = _selectedCustomerId; //Sets the ownerId value in the storedObject to the new selected value.
      });

      DatabaseService.updateObjectTotal(widget.object);
      widget.pc.close(); //Close the panel
      widget.updateFunction(); //update parent widget
    }
  }

  //Builds buttons for actions with customer data
  _buildCustomerAction(String label, IconData icon, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          SizedBox(width: 20.0),
          Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        offset: Offset(2, 2),
                        color: Colors.black12)
                  ],
                  color: MyColors.lightBlue,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Icon(
                icon,
                color: MyColors.primary,
              )),
          SizedBox(width: 16.0),
          Text(
            label,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  //Builds every attribute that exsist from customer in the UI
  _buildOwnerInfo(Customer customer) {
    return Column(
      children: <Widget>[
        Icon(
          Icons.person,
          size: 35.0,
          color: MyColors.primary,
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          customer.name,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        customer.address.isNotEmpty
            ? Text(customer.address)
            : SizedBox.shrink(),
        Text(
            '${customer.postalCode.isNotEmpty ? customer.postalCode + ' ' : ''}${customer.city.isNotEmpty ? customer.city : ''}'),
        SizedBox(
          height: 25.0,
        ),
        customer.phone.isNotEmpty
            ? _buildCustomerAction(customer.phone, Icons.phone,
                () => print('Call to :' + customer.phone))
            : SizedBox.shrink(),
        SizedBox(
          height: 16.0,
        ),
        customer.email.isNotEmpty
            ? _buildCustomerAction(customer.email, Icons.mail,
                () => print('Mail to :' + customer.email))
            : SizedBox.shrink(),
        SizedBox(
          height: 16.0,
        ),
        customer.gdpr
            ? _buildCustomerAction('GDPR godkänt', Icons.check_box, null)
            : _buildCustomerAction(
                'GDPR ej godkänt', Icons.check_box_outline_blank, null)
      ],
    );
  }

  _updateCustomer() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Customer customer = Customer(
          id: _currentCustomer.id,
          name: _name,
          address: _address,
          postalCode: _postalCode,
          city: _city,
          phone: _phone,
          email: _email,
          gdpr: _gdpr,
          timestamp: _currentCustomer.timestamp);

      DatabaseService.updateCustomer(customer);
    }
  }

  //Dialog to update attributes of a customer (Does not have GDPR checkbox)
  _showEditDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Redigera ${_currentCustomer.name}s uppgifter'),
            content: Form(
              key: _formKey,
              child: Container(
                height: 530.0,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _currentCustomer.name,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Namn',
                      ),
                      validator: (input) => input.trim().length < 1
                          ? 'Ange ett giltigt namn'
                          : null,
                      onSaved: (input) => _name = input,
                    ),
                    TextFormField(
                      initialValue: _currentCustomer.address,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Adress',
                      ),
                      onSaved: (input) => _address = input,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 110.0,
                          child: TextFormField(
                            initialValue: _currentCustomer.postalCode,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: 'Postkod',
                            ),
                            onSaved: (input) => _postalCode = input,
                          ),
                        ),
                        Container(
                          width: 110.0,
                          child: TextFormField(
                            initialValue: _currentCustomer.city,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: 'Stad',
                            ),
                            onSaved: (input) => _city = input,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      initialValue: _currentCustomer.phone,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Telefonnummer',
                      ),
                      onSaved: (input) => _phone = input,
                    ),
                    TextFormField(
                      initialValue: _currentCustomer.email,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'E-post',
                      ),
                      onSaved: (input) => _email = input,
                    ),
                    SizedBox(height: 30.0),
                    SizedBox(height: 30.0),
                    FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: MyColors.primary,
                        onPressed: () {
                          _updateCustomer();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Uppdatera',
                          style: TextStyle(color: Colors.white),
                        )),
                    SizedBox(height: 10.0),
                    FlatButton(
                        textColor: Colors.redAccent,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  title: Text(
                                      'Vill du radera ${_currentCustomer.name}?'),
                                  content: Text(
                                      'Detta kan inte ångras i efterhand.'),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Avbryt')),
                                    FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          DatabaseService.deleteCustomerById(
                                              _currentCustomer.id);
                                          widget.object.ownerId = null; //Tells object it doesn't have a owner
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          widget.pc.close(); //Close panel
                                          widget.updateFunction(); //updates info in parent widget
                                        },
                                        child: Text('Radera'))
                                  ],
                                );
                              });
                        },
                        child: Text('Radera kund')),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => widget.pc.close()),
              Text(
                'Ägare',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              _hasOwner
                  ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showEditDialog(context))
                  : IconButton(
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
        widget.object.ownerId != null
            ? FutureBuilder(
                future: DatabaseService.getCustomerById(widget.object.ownerId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox.shrink();
                  }
                  if (!snapshot.data.exists) {
                    return Container(
                        height: 250.0,
                        child: Center(
                            child: Text(
                                'Ingen ägare tilldelad till objektet...')));
                  }
                  Customer customer = Customer.fromDoc(snapshot.data);
                  _currentCustomer = customer;
                  _gdpr = customer.gdpr;
                  return _buildOwnerInfo(customer);
                })
            : Container(
                height: 250.0,
                child: Center(
                    child: Text('Ingen ägare tilldelad till objektet...'))),
        Expanded(
          child: Center(),
        ),
        Divider(),
        MyLayout.oneItemNoExpand(
            SearchableDropdown.single(
              closeButton: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Stäng')),
                ],
              ),
              items: _customers,
              value: _selectedCustomer,
              hint: Text(
                "Byt ägare",
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
            null),
        SizedBox(
          height: 16.0,
        ),
        FlatButton(
            onPressed: () => _submitUpdatedOwner(), child: Text('Uppdatera')),
        SizedBox(
          height: 33.0,
        ),
      ],
    );
  }
}
