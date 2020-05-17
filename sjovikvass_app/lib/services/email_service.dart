import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailService {
  static showEmailDialog(
      BuildContext context, String contactName, String email) {
    return Platform.isIOS
        ? iosBottomSheet(context, contactName, email)
        : androidDialog(context, contactName, email);
  }

  static iosBottomSheet(
      BuildContext context, String contactName, String email) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Vill du maila ' + contactName + '?'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                'Ja',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                if (email != '') {
                  launch("mailto: " + email);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  _errorMsg(context, contactName, email);
                }
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Avbryt'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static _errorMsg(
      BuildContext context, String contactName, String phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Något gick snett :-("),
          content: new Text(contactName + " har ingen angiven mailadress!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Stäng"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static androidDialog(BuildContext context, String contactName, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Vill du maila ' + contactName + '?'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Ja'),
              onPressed: () {
                if (email != '') {
                  launch("mailto: " + email);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  _errorMsg(context, contactName, email);
                }
              },
            ),
            SimpleDialogOption(
              child: Text(
                'Avbryt',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
