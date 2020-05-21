import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sjovikvass_app/models/contact_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/email_service.dart';
import 'package:sjovikvass_app/services/phoneCall_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/my_button.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

//List tile that displays a contact.

class ContactTile extends StatefulWidget {
  final ContactModel contact;
  final String inSupplierId;
  final String supplierMainContact;

  ContactTile({
    this.contact,
    this.inSupplierId,
    this.supplierMainContact,
  });
  @override
  _ContactTileState createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  @override
  Widget build(BuildContext context) {
    //Slidable that makes it possible to delete a contact
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
            color: Colors.transparent,
            foregroundColor: Colors.red,
            caption: 'Radera',
            icon: Icons.delete,
            onTap: () => DatabaseService.removeContact(
                widget.inSupplierId, widget.contact.id)),
      ],

      //The container that shows the contact information
      child: Container(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          height: 140.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0, // has the effect of softening the shadow
                spreadRadius: 2.0, // has the effect of extending the shadow
                offset: Offset(
                  3.0, // horizontal, move right 10
                  3.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  Container(
                    width: 250.0,
                    child: Text(
                      widget.contact.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Spacer(),
                  Checkbox(
                    value: widget.contact.isMainContact,
                    onChanged: (bool value) {
                      setState(
                        () {
                          // check if the contact isnt already the main contact.
                          // if it isnt already then we update it
                          if (widget.supplierMainContact != widget.contact.id) {
                            DatabaseService.updateContactIsMainContact(
                                widget.inSupplierId, widget.contact.id);

                            //update the main contact variable in the supplier
                            if (value == true) {
                              DatabaseService.updateSupplierMainContact(
                                  widget.inSupplierId, widget.contact.id);
                            }
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(width: 17),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 305),
                  Text(
                    'Huvudkontakt',
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 50),
              // SizedBox(height: 10),
              Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  MyLightBlueButton(
                      icon: Icons.phone,
                      label: 'Ring',
                      onTap: () => PhoneCallService.showPhoneCallDialog(context,
                          widget.contact.name, widget.contact.phoneNumber)),
                  SizedBox(width: 20),
                  MyLightBlueButton(
                      icon: Icons.mail,
                      label: 'Maila',
                      onTap: () => EmailService.showEmailDialog(
                          context, widget.contact.name, widget.contact.email)),
                  SizedBox(width: 15),
                  Container(
                      height: 50,
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Tel: ' + widget.contact.phoneNumber,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Mail: ' + widget.contact.email,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ))
                ],
              ),
            ],
          )),
    );
  }
}
