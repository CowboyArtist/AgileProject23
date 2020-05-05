import 'package:flutter/material.dart';
import 'package:sjovikvass_app/models/supplier_model.dart';
import 'package:sjovikvass_app/styles/commonWidgets/detailAppBar.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

class SupplierDetailScreen extends StatefulWidget {
  @override
  _SupplierDetailScreenState createState() => _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DetailAppBar.buildAppBar('Leverantör', context),
        body: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300.0,
                  child: Text(
                    'Det var en gång en stor kanske ionte ens liote kgyasik sdjkfs dhfgs jkffsjdhjsekfh ksh fh wkfg wekfwhk fhejkfhwekj huwfkhkfwejkfh wefkhwk fjhwefkjhwefuhwfouiwhuoa iufeah flaughurghaeui h fuiwh wuf wuiefh auklfeh aiwulfg aifhkfhaw ekfhaukf h ',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 30.0,
                  height: 30.0,
                  child: RaisedButton(
                    color: MyColors.lightBlue,
                    child: Icon(
                      Icons.phone,
                      color: MyColors.primary,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    padding: EdgeInsets.all(10.0),
                    onPressed: () => print('Phone Button Pressed'),
                  ),
                ),
                ButtonTheme(
                  minWidth: 30.0,
                  height: 30.0,
                  child: RaisedButton(
                    color: MyColors.lightBlue,
                    child: Icon(
                      Icons.mail,
                      color: MyColors.primary,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    padding: EdgeInsets.all(10.0),
                    onPressed: () => print('Email Button Pressed'),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 115.0,
                ),
                Text('Ring',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 122.0,
                ),
                Text('Maila',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey))
              ],
            )
          ],
        ));
  }
}
