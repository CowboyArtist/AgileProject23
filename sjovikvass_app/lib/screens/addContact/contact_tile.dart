import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sjovikvass_app/models/contact_model.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/email_service.dart';
import 'package:sjovikvass_app/services/phoneCall_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

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
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            Positioned(
              left: 16.0,
              top: 16.0,
              child: Container(
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
            ),
            Positioned(
              right: 40.0,
              top: 40.0,
              child: Container(
                height: 120,
                width: 220.0,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.contact.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16.0,
              bottom: 32.0,
              child: ButtonTheme(
                minWidth: 30.0,
                height: 30.0,
                child: RaisedButton(
                  color: MyColors.lightBlue,
                  child: Icon(
                    Icons.phone,
                    color: MyColors.primary,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  padding: EdgeInsets.all(10.0),
                  onPressed: () => PhoneCallService.showPhoneCallDialog(
                      context, widget.contact.name, widget.contact.phoneNumber),
                ),
              ),
            ),
            Positioned(
              left: 80.0,
              bottom: 32.0,
              child: ButtonTheme(
                minWidth: 30.0,
                height: 30.0,
                child: RaisedButton(
                  color: MyColors.lightBlue,
                  child: Icon(
                    Icons.mail,
                    color: MyColors.primary,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  padding: EdgeInsets.all(10.0),
                  onPressed: () => EmailService.showEmailDialog(
                      context, widget.contact.name, widget.contact.email),
                ),
              ),
            ),
            Positioned(
              left: 24.0,
              bottom: 10.0,
              child: Text(
                'Ring',
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ),
            Positioned(
              left: 85.0,
              bottom: 10.0,
              child: Text(
                'Maila',
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ),
            Positioned(
              top: 4.0,
              right: 16.0,
              child: Checkbox(
                value: widget.contact.isMainContact,
                onChanged: (bool value) {
                  setState(
                    () {
                      if (widget.supplierMainContact != widget.contact.id) {
                        DatabaseService.updateContactIsMainContact(
                            widget.inSupplierId, widget.contact.id);
                        if (value == true) {
                          DatabaseService.updateSupplierMainContact(
                              widget.inSupplierId, widget.contact.id);
                        }
                      }
                    },
                  );
                },
              ),
            ),
            Positioned(
              top: 40.0,
              right: 10.0,
              child: Text(
                'Huvudkontakt',
                style: TextStyle(
                  fontSize: 10.0,
                ),
              ),
            ),
            Positioned(
              bottom: 5.0,
              right: 15.0,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => print('Edit a Contact'),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
