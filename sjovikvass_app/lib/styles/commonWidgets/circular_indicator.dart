import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../my_colors.dart';

class MyCircularProcentIndicator {
  static buildIndicator(int doneOrders, int totalOrders) {
    return CircularPercentIndicator(
      radius: 100.0,
      progressColor: MyColors.primary,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 18.0,
          ),
          Text(
            totalOrders == 0
                ? '0 %'
                : "${(doneOrders / totalOrders * 100).round()}%",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: MyColors.primary),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Klart',
            style: TextStyle(fontSize: 12.0),
          ),
        ],
      ),
      lineWidth: 8.0,
      percent: doneOrders / totalOrders,
      animation: true,
    );
  }
  static buildCustomIndicator(int doneOrders, int totalOrders, double radius, Color color) {
    return CircularPercentIndicator(
      radius: radius,
      progressColor: color.withAlpha(230),
      center: Text(
        totalOrders == 0
            ? '0 %'
            : "${(doneOrders / totalOrders * 100).round()}%",
        style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: color.withAlpha(190)),
      ),
      lineWidth: 4.0,
      percent: doneOrders / totalOrders,
      animation: true,
    );
  }
  static buildCustomIndicatorFromDouble(double percent, double radius, Color color) {
    return CircularPercentIndicator(
      radius: radius,
      progressColor: color.withAlpha(230),
      center: Text(
        percent == 0
            ? '0 %'
            : "${(percent * 100).round()}%",
        style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: color.withAlpha(190)),
      ),
      lineWidth: 4.0,
      percent: percent,
      animation: true,
    );
  }
}
