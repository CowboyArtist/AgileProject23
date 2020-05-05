import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/stored_object_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OwnerDetails extends StatefulWidget {
  final PanelController pc;
  final StoredObject object;
  OwnerDetails({this.pc, this.object});
  @override
  _OwnerDetailsState createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => widget.pc.close()),
              Text(
                'Justera Ägare',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: null)
            ]),
        Divider(height: 1.0),
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}
