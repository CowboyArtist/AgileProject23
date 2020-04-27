

import 'package:flutter/material.dart';
import 'package:sjovikvass_app/screens/workPage/widgets/price_dialog_widget.dart';

class DialogHelper {

  static exit(context) => showDialog(context: context, builder: (context) => PriceDialog());
}