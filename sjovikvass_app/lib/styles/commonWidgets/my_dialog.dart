import 'package:flutter/material.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

//Custom dialog for the app.
class MyDialog extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String body;
  final String done;

  MyDialog({
    this.onPressed,
    this.title,
    this.body,
    this.done,
  });

  @override
  Widget build(BuildContext context) {
    return

        // set up the AlertDialog
        AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(title),
      content: Text(body),
      actions: [
        FlatButton(
          child: Text("Avbryt", style: TextStyle(color: Colors.redAccent)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: MyColors.primary,
          child: Text(done),
          onPressed: () {
            onPressed();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
