import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fascia_care/screens/water-screen.dart';
import 'package:fascia_care/service/sharedPreferences.dart';
import 'package:fascia_care/service/waterService.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Water extends StatefulWidget {
  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final LocalSharedPreferences sharedPreferences = LocalSharedPreferences();
  final WaterService waterService = WaterService();
  final ProfileService profileService = ProfileService();
  int newWaterIntake;
  double newProgressValue;

  ValueNotifier<String> waterIntake;

  void getIntakeProgress() {
    var newProgressValue =
        ((1 * double.parse(profileService.dailyWaterIntake)) /
            double.parse(profileService.waterIntake));
    setState(() {
      profileService.dailyIntakeProgress = newProgressValue;
      profileService.dailyIntakePercent =
          ((newProgressValue * 100).round()).toString();
    });
  }

  void onWaterChartPage(ctx) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: (ctx) {
      return WaterScreen();
    }));
  }

  @override
  void initState() {
    super.initState();
    print('Water');
    //getIntakeProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => {onWaterChartPage(context)},
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[900],
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Icon(
                      SimpleLineIcons.drop,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('Water',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 20)),
                  ),
                  Container(
                    // margin: EdgeInsets.only(right:10),
                    child: Text('cup/${profileService.waterCup} mL',
                        style: TextStyle(fontSize: 15)),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${profileService.dailyWaterIntake}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('/${profileService.waterIntake} mL',
                          style: TextStyle(fontSize: 13)),
                    ],
                  )),
                  Material(
                    color: Colors.transparent,
                    child: Container(
                        // margin: const EdgeInsets.only(bottom:10),
                        child: Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 20,
                          icon: const Icon(
                            Icons.remove_circle,
                            size: 40,
                          ),
                          color: Colors.grey[700],
                          onPressed: () {
                            setState(() {
                              waterService.decrementIntake();
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 20,
                          icon: const Icon(
                            Icons.add_circle,
                            size: 40,
                          ),
                          color: Colors.grey[700],
                          onPressed: () {
                            setState(() {
                              waterService.incrementIntake();
                            });
                          },
                        ),
                      ],
                    )),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    child: LinearPercentIndicator(
                      percent: profileService.dailyIntakeProgress,
                      lineHeight: 20,
                      animation: true,
                      animationDuration: 1000,
                      backgroundColor: Colors.grey[700],
                      progressColor: Colors.blue,
                      center: Text(
                        '${profileService.dailyIntakePercent}%',
                        style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
