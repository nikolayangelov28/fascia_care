import 'dart:math';
import 'package:fascia_care/main.dart';
import 'package:fascia_care/service/waterService.dart';
import 'package:intl/intl.dart';
import 'package:fascia_care/screens/dashboard.dart';
import 'package:fascia_care/screens/home.dart';
import 'package:fascia_care/screens/water-screen-charts.dart';
import 'package:fascia_care/service/databaseService.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/widgets/custom-chart.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WaterScreen extends StatefulWidget {
  @override
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  final ProfileService profileService = ProfileService();
  final DatabaseService databaseService = DatabaseService();
  final WaterService waterService = WaterService();
/*   final appBar = AppBar(
      backgroundColor: Colors.grey[900],
      elevation: 0,
      title: Text('Water'),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () => {},
      )); */
  var appBar = Dashboard.appBar;
  var cupSizes = ['140mL', '240mL', '340mL'];
  var weeklyAchieveList = [];
  double _currentSliderValue = 140;
  List<charts.Series> seriesList;
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: Colors.grey[850],
      shape: StadiumBorder(),
      side: BorderSide());
  static List<charts.Series<ChartData, String>> _createData() {
    final random = Random();
    final chartData = [
      ChartData('15', 0),
      ChartData('16', random.nextInt(200)),
      ChartData('17', random.nextInt(200)),
      ChartData('18', 2400),
      ChartData('19', 3122),
      ChartData('20', 2940),
    ];

    return [
      charts.Series<ChartData, String>(
          id: 'Water Intake',
          domainFn: (ChartData water, _) => water.date,
          measureFn: (ChartData water, _) => water.waterIntake,
          data: chartData)
    ];
  }

  void route() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }));
  }

  void routeToCharts() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WaterCharts();
    }));
  }

  void changeCupSize(index) {
    if (index == 0) {
      profileService.waterCup = '140';
      profileService.waterCupIndex = 0;
    }
    if (index == 1) {
      profileService.waterCup = '240';
      profileService.waterCupIndex = 1;
    }
    if (index == 2) {
      profileService.waterCup = '340';
      profileService.waterCupIndex = 2;
    }
  }

  Future setWeeklyAchievement() async {
    var weekDay;
    var weeklyAchieve;
    await databaseService.getWeeklyAchievement().then((value) => {
          weeklyAchieve = value,
          for (int i = 0; i < 7; i++)
            {
              weekDay = DateTime.now().subtract(Duration(days: i)),
              weeklyAchieveList.add({
                'day': DateFormat.E().format(weekDay),
                'reached': weeklyAchieve[i]
              })
            }
        });
    return print(weeklyAchieveList.reversed);
  }

  @override
  void initState() {
    super.initState();
    seriesList = _createData();
    // test for refreshing the array with new value
/*     var arr = profileService.lastSevenDays;
    arr.add('true');
    arr.removeAt(0);
    print(arr); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: Text('Water'),
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => route(),
          ),
          actions: [
            IconButton(
              splashRadius: 20,
              icon: Icon(Icons.bar_chart_outlined),
              onPressed: () => routeToCharts(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) *
                    0.2,
                width: MediaQuery.of(context).size.width * 1,
                child: CustomChart(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15, top: 15),
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom) *
                        0.4,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Center(
                      child: LiquidCircularProgressIndicator(
                          value: profileService.dailyIntakeProgress,
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                          backgroundColor: Colors.grey[700],
                          borderColor: Colors.grey[800].withOpacity(0.7),
                          borderWidth: 10,
                          direction: Axis.vertical,
                          center: Text(profileService.dailyIntakePercent + '%',
                              style: TextStyle(
                                  fontSize: 35,
                                  shadows: [
                                    Shadow(
                                        offset: Offset(3.0, 3.0),
                                        blurRadius: 3.0,
                                        color: Color.fromARGB(255, 0, 0, 0))
                                  ],
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold))),
                    ),
                  ),
                ],
              ),
              Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) *
                    0.1,
                width: MediaQuery.of(context).size.width * 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${profileService.dailyWaterIntake}',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    Text('/${profileService.waterIntake} mL',
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    color: Colors.grey[900],
                  ),
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom) *
                      0.21,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Slider(
                              value: double.parse(profileService.waterCup),
                              inactiveColor: Colors.grey[800],
                              activeColor: Colors.blue[400],
                              min: 140,
                              max: 500,
                              divisions: 3,
                              label: profileService.waterCup + 'mL',
                              onChanged: (double value) {
                                setState(() {
                                  waterService.changeCup((value.toInt()).toString());
                                });
                              },
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${profileService.waterCup}' + 'mL',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text('/cup', style: TextStyle(fontSize: 13)),
                            ],
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            splashRadius: 20,
                            icon: const Icon(
                              Icons.remove_circle,
                              size: 50,
                            ),
                            color: Colors.grey[700],
                            onPressed: () {
                              setState(() {
                                waterService.incrementIntake();
                              });
                            },
                          ),
                          SizedBox(width: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.local_drink,
                                color: Colors.blue[400],
                                size: 40.0,
                              )
                            ],
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            splashRadius: 20,
                            icon: const Icon(
                              Icons.add_circle,
                              size: 50,
                            ),
                            color: Colors.grey[700],
                            onPressed: () {
                              setState(() {
                                waterService.incrementIntake();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }
}

/// Sample ordinal data type.r
class ChartData {
  final String date;
  final int waterIntake;

  ChartData(this.date, this.waterIntake);
}
