import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneCallService {
  static showPhoneCallDialog(
      BuildContext context, String companyName, String phoneNumber) {
    return Platform.isIOS
        ? iosBottomSheet(context, companyName, phoneNumber)
        : androidDialog(context, companyName, phoneNumber);
  }

  static iosBottomSheet(
      BuildContext context, String companyName, String phoneNumber) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Vill du ringa ' + companyName + '?'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                'Ring',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                launch("tel: " + phoneNumber);
                Navigator.pop(context);
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

  static androidDialog(
      BuildContext context, String companyName, String phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Vill du ringa ' + companyName + '?'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Ring'),
              onPressed: () {
                launch("tel: " + phoneNumber);
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
