import 'package:fascia_care/service/profileService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CustomChartBar extends StatelessWidget {
  final String date;
  final bool intakeReached;
  final now = DateFormat.E().format(new DateTime.now());
  ProfileService profileService = ProfileService();

  CustomChartBar(this.date, this.intakeReached);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: (date == now) ? Border.all(width: 0, color: Colors.transparent) : Border.all(width:0, color: Colors.transparent),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(
            Icons.check_circle,
            color: (intakeReached == true) ? Colors.blue[300] : Colors.grey[700],
            size: 35.0,
          ),
        ),
        SizedBox(height: 5),
        Text(date, style: (date == now) ? TextStyle(fontWeight: FontWeight.bold, color: Colors.white) : TextStyle(color: Colors.white38)
        )],
    );
  }
}
