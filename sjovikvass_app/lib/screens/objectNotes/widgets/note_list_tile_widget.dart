import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sjovikvass_app/models/object_note_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/services/time_service.dart';

class NoteListTile extends StatefulWidget {
  final String inObjectId;
  final ObjectNote objectNote;

  NoteListTile({this.inObjectId, this.objectNote});

  @override
  _NoteListTileState createState() => _NoteListTileState();
}

class _NoteListTileState extends State<NoteListTile> {
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
            color: Colors.transparent,
            foregroundColor: Colors.red,
            caption: 'Radera',
            icon: Icons.delete,
            onTap: () => DatabaseService.removeNote(widget.inObjectId, widget.objectNote.id)),
      ],
              child: Container(
          margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
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
              TimeService.getFormattedDate(widget.objectNote.timestamp.toDate()),
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
