import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fascia_care/screens/activity-screen.dart';
import 'package:fascia_care/service/activityService.dart';
import 'package:fascia_care/service/databaseService.dart';
import 'package:fascia_care/service/sharedPreferences.dart';
import 'package:fascia_care/service/weatherService.dart';
import 'package:http/http.dart' as http;
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/widgets/water.dart';
import 'package:fascia_care/widgets/weather.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
  static final appBar = AppBar(
    title: Text('Dashboard'),
    centerTitle: true,
  );
}

class _DashboardState extends State<Dashboard> {
  final DatabaseService databaseService = DatabaseService();
  final LocalSharedPreferences sharedPreferences = LocalSharedPreferences();
  final ActivityService activityService = ActivityService();
  final WeatherService weatherService = WeatherService();
  final userCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ProfileService profileService = ProfileService();
  var appBar = Dashboard.appBar;
  final snackBar = SnackBar(
    content: Row(
      children: [
        Text('Hold down to make a change!'),
        Icon(
          Icons.touch_app,
          color: Colors.grey[850],
        )
      ],
    ),
    duration: Duration(milliseconds: 500),
  );

  var dailyIntakePercent;
  var dailyIntakeProgress;

  Future<void> getUserData() async {
    var uid = user.uid;
    var a = await userCollection.doc(uid).get();
    var data = a.data();
    var waterIntake = (data['waterIntake']).toString();
    var dailyIntake = (data['dailyWaterIntake']).toString();
    // var waterCup = (data['cup']).toString();
    var activityLevel = (data['activityLevel']);
    // cmment out when activity level is connected to DB
    setState(() {
      profileService.waterIntake = waterIntake;
      profileService.mainWaterIntake = waterIntake;
      profileService.dailyWaterIntake = dailyIntake;
      profileService.activityLevel = activityLevel;
      // profileService.waterCup = waterCup;
      dailyIntakeProgress =
          ((1 * double.parse(dailyIntake))) / double.parse(waterIntake);
      profileService.dailyIntakeProgress = dailyIntakeProgress;
      dailyIntakePercent =
          ((((1 * double.parse(dailyIntake)) / double.parse(waterIntake)) * 100)
                  .round())
              .toString();
      profileService.dailyIntakePercent = dailyIntakePercent;
    });
  }

  setLocalData() {
    //intake progress
    dailyIntakeProgress =
        ((1 * double.parse(profileService.dailyWaterIntake))) /
            double.parse(profileService.waterIntake);
    profileService.dailyIntakeProgress = dailyIntakeProgress;

    //intake percent
    dailyIntakePercent =
        ((((1 * double.parse(profileService.dailyWaterIntake)) /
                        double.parse(profileService.waterIntake)) *
                    100)
                .round())
            .toString();
    profileService.dailyIntakePercent = dailyIntakePercent;
  }

  void onActivityPage(ctx) {
    Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
      return ActivityScreen();
    }));
  }

  _mediaQueryHeight(ctx) => (MediaQuery.of(ctx).size.height -
      appBar.preferredSize.height -
      MediaQuery.of(ctx).padding.top -
      MediaQuery.of(ctx).padding.bottom);

  Future updateWeather() async {
    await weatherService.getCurrentLocation().then((value) {
      setState(() {
        print('weather updated');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          child: Column(
            children: [
              Container(
                height: _mediaQueryHeight(context) * 0.25,
                width: MediaQuery.of(context).size.width * 1,
                child: Water(),
              ),
              SizedBox(height: 10),
              Container(
                  height: _mediaQueryHeight(context) * 0.25,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Material(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => {onActivityPage(context)},
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
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.directions_run,
                                    color: Colors.green,
                                    size: 30.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('Activity level',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 20)),
                                ),
                                Container(
                                  child: Text(
                                      '+' +
                                          profileService.activityIncreaseValue,
                                      style: TextStyle(fontSize: 15)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: Container(
                                      // margin: const EdgeInsets.only(bottom:10),
                                      child: Row(
                                    children: [
                                      GestureDetector(
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            splashRadius: 15,
                                            splashColor: Colors.green,
                                            icon: (profileService
                                                        .activityLevel ==
                                                    1)
                                                ? const Icon(Icons.looks_one,
                                                    size: 40)
                                                : const Icon(
                                                    Icons.looks_one_outlined,
                                                    size: 40,
                                                  ),
                                            color:
                                                (profileService.activityLevel ==
                                                        1)
                                                    ? Colors.green
                                                    : Colors.grey[700],
                                            onPressed: () => {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar)
                                            },
                                          ),
                                          onLongPress: () {
                                            setState(() {
                                              activityService.activityChange(1);
                                            });
                                          }),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            splashRadius: 15,
                                            splashColor: Colors.green,
                                            icon: (profileService
                                                        .activityLevel ==
                                                    2)
                                                ? const Icon(Icons.looks_two,
                                                    size: 40)
                                                : const Icon(
                                                    Icons.looks_two_outlined,
                                                    size: 40,
                                                  ),
                                            color:
                                                (profileService.activityLevel ==
                                                        2)
                                                    ? Colors.green
                                                    : Colors.grey[700],
                                            onPressed: () => {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar)
                                            },
                                          ),
                                          onLongPress: () {
                                            setState(() {
                                              activityService.activityChange(2);
                                            });
                                          }),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            splashRadius: 15,
                                            splashColor: Colors.green,
                                            icon:
                                                (profileService.activityLevel ==
                                                        3)
                                                    ? const Icon(Icons.looks_3,
                                                        size: 40)
                                                    : const Icon(
                                                        Icons.looks_3_outlined,
                                                        size: 40,
                                                      ),
                                            color:
                                                (profileService.activityLevel ==
                                                        3)
                                                    ? Colors.green
                                                    : Colors.grey[700],
                                            onPressed: () => {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar)
                                            },
                                          ),
                                          onLongPress: () {
                                            setState(() {
                                              activityService.activityChange(3);
                                            });
                                          }),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            splashRadius: 15,
                                            splashColor: Colors.green,
                                            icon:
                                                (profileService.activityLevel ==
                                                        4)
                                                    ? const Icon(Icons.looks_4,
                                                        size: 40)
                                                    : const Icon(
                                                        Icons.looks_4_outlined,
                                                        size: 40,
                                                      ),
                                            color:
                                                (profileService.activityLevel ==
                                                        4)
                                                    ? Colors.green
                                                    : Colors.grey[700],
                                            onPressed: () => {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar)
                                            },
                                          ),
                                          onLongPress: () {
                                            setState(() {
                                              activityService.activityChange(4);
                                            });
                                          }),
                                    ],
                                  )),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(profileService.activityLevelText,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 10),
              Container(
                  height: _mediaQueryHeight(context) * 0.25,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Weather()),
            ],
          )),
    );
  }
}
