import 'package:fascia_care/service/databaseService.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/widgets/custom-chart-bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomChart extends StatelessWidget {
  final ProfileService profileService = ProfileService();
  final DatabaseService databaseService = DatabaseService();
  final List weeklyAchieveList = [];

  List<Map<String, Object>> get weeklyIntake {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var intakeReached = profileService.lastSevenDays[index];
      //var intakeReached = weeklyIntake[1];
      // print(DateFormat.E().format(weekDay));
      return {'day': DateFormat.E().format(weekDay), 'reached': intakeReached};
    }).reversed.toList();
  }

  Future setWeeklyAchievement() async {
    var weekDay;
    var weeklyAchieve;
    await databaseService.getWeeklyAchievement().then((value) => {
          weeklyAchieve = value,
          for (int i = 1; i <= 7; i++)
            {
              weekDay = DateTime.now().subtract(Duration(days: i)),
              weeklyAchieveList.add({
                'day': DateFormat.E().format(weekDay),
                'reached': weeklyAchieve[i - 1]
              })
            }
        });
    return weeklyAchieveList;
  }

  @override
  Widget build(BuildContext context) {
    //print('old one');
    //print(weeklyIntake);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey[900]),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text('Weekly Achievement'),
          SizedBox(height: 10),
          Container(
            child: FutureBuilder(
                future: setWeeklyAchievement(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue)));
                  } else {
                    if (snapshot.hasError)
                      return Center(child: Text('Error: ${snapshot.error}'));
                    else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: weeklyAchieveList.map((data) {
                          return CustomChartBar(data['day'], data['reached']);
                        }).toList(),
                      );
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }
}
