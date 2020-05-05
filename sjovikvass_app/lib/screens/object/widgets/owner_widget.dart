import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:sjovikvass_app/models/customer_model.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/screens/object/widgets/my_layout_widget.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:sjovikvass_app/utils/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OwnerDetails extends StatefulWidget {
  final PanelController pc;
  final StoredObject object;
  final Function updateFunction;
  OwnerDetails({this.pc, this.object, this.updateFunction});
  @override
  _OwnerDetailsState createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  List<DropdownMenuItem<String>> _customers = [];

  var _selectedCustomer;
  String _selectedCustomerId;

  @override
  void initState() {
    super.initState();
    _setupCustomerList();
  }

  _setupCustomerList() {
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

  _submitUpdatedOwner() {
    if (_selectedCustomer.isNotEmpty) {
      List<String> helperList = _selectedCustomer.split('/');
      _selectedCustomerId = helperList[1];
      setState(() {
        widget.object.ownerId = _selectedCustomerId;
      });

      DatabaseService.updateObjectTotal(widget.object);
      widget.pc.close();
      widget.updateFunction();
    }
  }

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
                  child: Icon(icon, color: MyColors.primary,)),
              SizedBox(width: 16.0),
              Text(
                label,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
              )
            ],
          ),
        );
  }

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
        ? _buildCustomerAction(customer.phone, Icons.phone, () => print('Call to :' + customer.phone) ) : SizedBox.shrink(),

        SizedBox(
          height: 16.0,
        ),
        customer.email.isNotEmpty ? _buildCustomerAction(customer.email, Icons.mail, () => print('Mail to :' + customer.email)): SizedBox.shrink(),
        SizedBox(
          height: 16.0,
        ),
        customer.gdpr ? _buildCustomerAction('GDPR godkänt', Icons.check_box, null) : _buildCustomerAction('GDPR ej godkänt', Icons.check_box_outline_blank, null)
      ],
    );
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
        widget.object.ownerId != null ?
        FutureBuilder(
            future: DatabaseService.getCustomerById(widget.object.ownerId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }
              Customer customer = Customer.fromDoc(snapshot.data);
              return _buildOwnerInfo(customer);
            }): Container(height: 250.0, child: Center(child: Text('Ingen ägare tilldelad till objektet...'))),
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
