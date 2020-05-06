import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/object_note_model.dart';
import 'package:sjovikvass_app/screens/objectNotes/widgets/note_list_tile_widget.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

class NotePage extends StatefulWidget {
  final String inObjectId;

  NotePage({
    this.inObjectId,
  });

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  _setupObjectNotes() async {
    int totalNotes = await DatabaseService.getAllObjectNotes(widget.inObjectId);
  }

  @override
  void initState() {
    super.initState();
    _setupObjectNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar.buildAppBar('Anteckningar', context),
      body: Column(
        children: <Widget>[
          Expanded(
            child:
                //Stream that updates the UI when values in database changes.
                StreamBuilder(
                    stream: DatabaseService.getObjectNotes(widget.inObjectId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Hämtar data');
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          ObjectNote objectNote = ObjectNote.fromDoc(
                              snapshot.data.documents[index]);

                          return NoteListTile(
                            inObjectId: widget.inObjectId,
                            objectNote: objectNote,
                          );
                        },
                      );
                    }),
          ),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () => _createNoteDialog(context),
        child: Container(
            margin: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 40.0),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: MyColors.primary,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3, 3),
                      blurRadius: 5.0)
                ],
                borderRadius: BorderRadius.circular(10.0)),
            child: Center(
                child: Text(
              'Ny Anteckning',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }

  _createNoteDialog(BuildContext buildContext) {
    TextEditingController noteController = TextEditingController();

    return showDialog(
        context: buildContext,
        builder: (buildContext) {
          return AlertDialog(
            title: Text("Anteckning"),
            content: Container(
              height: 100.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 250.0,
                    height: 100.0,
                    child: TextField(
                      controller: noteController,
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('Lägg till'),
                onPressed: () {
                  Navigator.of(context).pop(noteController.text.toString());
                  DatabaseService.addNoteToObject(
                    ObjectNote(
                      text: noteController.text,
                    ),
                    widget.inObjectId,
                  );
                  print('tillagd');
                },
              )
            ],
          );
        });
  }
}
