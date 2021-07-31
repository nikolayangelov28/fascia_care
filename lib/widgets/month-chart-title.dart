import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineTitleMonth {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '1';
              case 4:
                return '5';
              case 9:
                return '10';
              case 14:
                return '15';
              case 19:
                return '20';
              case 24:
                return '25';
              case 30:
                return '31';
            }
            return '';
          },
          margin: 5,
        ),
        leftTitles: SideTitles(
          margin: 5,
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1000:
                return '1L';
              case 2000:
                return '2L';
              case 3000:
                return '3L';
              case 4000:
                return '4L';
              case 5000:
                return '5L';
            }
            return '';
          },
          reservedSize: 25,
        ),
      );
}
