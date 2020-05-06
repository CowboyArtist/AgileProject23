import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/object_note_model.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';
import 'package:intl/intl.dart';

class NoteListTile extends StatefulWidget {
  final String inObjectId;
  final ObjectNote objectNote;

  NoteListTile({this.inObjectId, this.objectNote});

  @override
  _NoteListTileState createState() => _NoteListTileState();
}

class _NoteListTileState extends State<NoteListTile> {
  final DateFormat _dateFormatter = DateFormat('dd MMM');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 10.0),
        decoration: BoxDecoration(
          color: MyColors.lightBlue,
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
        child: ListTile(
          title: Text(
            widget.objectNote.text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            _dateFormatter.format(widget.objectNote.timestamp.toDate()),
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
