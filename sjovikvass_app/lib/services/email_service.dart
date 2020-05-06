import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailService {
  static showEmailDialog(
      BuildContext context, String companyName, String email) {
    return Platform.isIOS
        ? iosBottomSheet(context, companyName, email)
        : androidDialog(context, companyName, email);
  }

  static iosBottomSheet(
      BuildContext context, String companyName, String email) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Vill du maila ' + companyName + '?'),
          actions: <Widget>[
            CupertinoActionSheetAction(
                child: Text(
                  'Ja',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  launch("mailto: " + email);
                  Navigator.pop(context);
                }),
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

  static androidDialog(BuildContext context, String companyName, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Vill du maila ' + companyName + '?'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Ja'),
              onPressed: () {
                launch("mailto: " + email);
                Navigator.pop(context);
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
