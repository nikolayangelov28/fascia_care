import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineTitleYear {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          rotateAngle: 35,
          reservedSize: 35,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'Jan';
              case 1:
                return 'Feb';
              case 2:
                return 'Mar';
              case 3:
                return 'Apr';
              case 4:
                return 'May';
              case 5:
                return 'Jun';
              case 6:
                return 'Jul';
              case 7:
                return 'Aug';
              case 8:
                return 'Sep';
              case 9:
                return 'Oct';
              case 10:
                return 'Nov';
              case 11:
                return 'Dec';
            }
            return '';
          },
          margin: 5,
        ),
        leftTitles: SideTitles(
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
              case 5000:
                return '5L';
              case 6000:
                return '6L';
              case 7000:
                return '7L';
              case 8000:
                return '8L';
              case 9000:
                return '9L';
              case 10000:
                return '10L';
            }
            return '';
          },
          reservedSize: 25,
        ),
      );
}
