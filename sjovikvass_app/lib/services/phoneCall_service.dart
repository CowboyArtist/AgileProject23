import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneCallService {
  static showPhoneCallDialog(
      BuildContext context, String contactName, String phoneNumber) {
    return Platform.isIOS
        ? iosBottomSheet(context, contactName, phoneNumber)
        : androidDialog(context, contactName, phoneNumber);
  }

  static iosBottomSheet(
      BuildContext context, String contactName, String phoneNumber) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Vill du ringa ' + contactName + '?'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                'Ring',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                if (phoneNumber != '') {
                  launch("tel: " + phoneNumber);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  _errorMsg(context, contactName, phoneNumber);
                }
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Avbryt'),
              onPressed: () => Navigator.pop(context),
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
          content: new Text(contactName + " har inget angivet telefonnummer!"),
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

  static androidDialog(
      BuildContext context, String contactName, String phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Vill du ringa ' + contactName + '?'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Ring'),
              onPressed: () {
                if (phoneNumber != '') {
                  launch("tel: " + phoneNumber);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  _errorMsg(context, contactName, phoneNumber);
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
