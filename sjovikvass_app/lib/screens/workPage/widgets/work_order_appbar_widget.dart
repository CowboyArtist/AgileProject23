import 'package:flutter/material.dart';

import 'package:sjovikvass_app/screens/workPage/widgets/season_page_widget.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

//Custom AppBar for the SeasonPage

class WorkOrderAppBar {
  static AppBar buildAppBar(
      String title, BuildContext context, String objectId) {
    List<DropdownMenuItem<String>> listDropItems = [];
    listDropItems.add(DropdownMenuItem(
      child: Text('Arkiv'),
    ));

    return AppBar(
      leading: Padding(
        padding: EdgeInsets.only(left: 5.0),
        child: InkResponse(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: InkResponse(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SeasonPage(
                            objectId: objectId,
                          )));
            },
            child: Icon(
              Icons.folder,
              size: 30.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
      backgroundColor: MyColors.backgroundLight,
    );
  }
}
