import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sjovikvass_app/services/database_service.dart';

class AddObjectScreen extends StatefulWidget {
  @override
  _AddObjectScreenState createState() => _AddObjectScreenState();
}

class _AddObjectScreenState extends State<AddObjectScreen> {

  TextEditingController _titleController = TextEditingController();
  String _title = '';
  
  TextEditingController _descriptionController = TextEditingController();
  String _description = '';
  


  _submitStoredObject() async {

    StoredObject storedObject = StoredObject(
      title: 'Testobjekt',
      description: 'Detta är ett testobjekt',
      model: 'Testy 3000'
    );
    print(storedObject.title + 'is created');

    DatabaseService.addObjectToDB(storedObject);

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lägg till'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'Nytt Objekt',
              ),
              Tab(
                text: 'Ny Leverantör',
              ),
            ],
          ),
        ),
        body: TabBarView(children: <Widget>[
          Column(
            children: <Widget>[
              Center(
                child: Text('Lägg till objekt'),
              ),
              FlatButton(onPressed: _submitStoredObject, child: Text('Lägg till testobjekt'))
            ],
          ),
          Center(
            child: Text('Lägg till Leverantör'),
          ),
        ]),
      ),
    );
  }
}
