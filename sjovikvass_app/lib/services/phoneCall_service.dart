import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneCallService {
  static showPhoneCallDialog(BuildContext context) {
    return Platform.isIOS ? iosBottomSheet(context) : androidDialog(context);
  }

  static iosBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Lägg till foto'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Ta ett foto'),
                onPressed: () => print('Kör metod för att ta foto'),
              ),
              CupertinoActionSheetAction(
                child: Text('Från galleriet'),
                onPressed: () {
                  //handling(ImageSource.gallery);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('Avbryt'),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  static androidDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Vill du ringa nr?'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Ring'),
              onPressed: () {
                launch("tel: +46723038454");
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
