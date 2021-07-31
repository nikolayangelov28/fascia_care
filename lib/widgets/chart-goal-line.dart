import 'package:fascia_care/main.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GoalLine {
  static getGoalLine() => ExtraLinesData(horizontalLines: [
        HorizontalLine(
            y: double.parse(profileService.waterIntake),
            strokeWidth: 2,
            label: HorizontalLineLabel(
              show: true,
              alignment: Alignment.topCenter,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            color: Colors.white.withOpacity(0.5))
      ]);
}