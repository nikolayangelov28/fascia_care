import 'package:fascia_care/screens/water-screen-charts.dart';
import 'package:fascia_care/service/databaseService.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/widgets/chart-goal-line.dart';
import 'package:fascia_care/widgets/year-chart-title.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class YearChart extends StatefulWidget {
  @override
  _YearChartState createState() => _YearChartState();
}

final List<Color> gradientColors = [
  const Color(0xff2196f3),
];

class _YearChartState extends State<YearChart>
    with AutomaticKeepAliveClientMixin {
  final ProfileService profileService = ProfileService();
  final DatabaseService databaseService = DatabaseService();
  List<FlSpot> yearChartList = [];
  FlSpot chartDot;
  int reachedGoals = 0;
  int intakeSum = 0;
  String intakeSumString = '0';
  int averageIntake = 0;
  bool isDataLoaded = false;

  // get data and create whole chart with external info
  Future createChart() async {
    await setData().then((value) => {
          intakeSumString = (intakeSum / 1000).toStringAsFixed(2),
          averageIntake = (intakeSum / 365).round()
        });
  }

  Future setData() async {
    var intake;
    var goal;
    await databaseService.getYearData().then((value) => {
          for (int i = 1; i <= 12; i++)
            {
              intake = value.data()['$i']['intake'],
              goal = value.data()['$i']['goalsReached'],
              intakeSum = (intakeSum + intake),
              reachedGoals = reachedGoals + goal,
              chartDot = FlSpot(((i - 1).toDouble()), intake.toDouble()),
              yearChartList.add(chartDot),
            }
        });
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: createChart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))
                //Text('Please wait its loading...')
                );
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text('Year Chart'),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.height -
                            WaterCharts().appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom) *
                        0.4,
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    child: LineChart(LineChartData(
                      extraLinesData: GoalLine.getGoalLine(),
                      minX: 0,
                      maxX: 11,
                      minY: 0,
                      maxY: 10000,
                      titlesData: LineTitleYear.getTitleData(),
                      gridData: FlGridData(
                        show: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: const Color(0xff616161),
                            strokeWidth: 0.2,
                          );
                        },
                        drawVerticalLine: true,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: const Color(0xff616161),
                            strokeWidth: 0,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                            color: const Color(0xff616161), width: 1),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: yearChartList,
                          isCurved: false,
                          dotData: FlDotData(
                            show: false,
                          ),
                          colors: gradientColors,
                          barWidth: 1.5,
                          // dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.4))
                                .toList(),
                          ),
                        ),
                      ],
                    )),
                  ),
                  Container(
                    height: 130,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.waves,
                                  color: Colors.blue,
                                  size: 40.0,
                                ),
                                Text('Total'),
                                SizedBox(
                                  height: 15,
                                ),
                                Text('$intakeSumString L',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.track_changes,
                                  color: Colors.blue,
                                  size: 40.0,
                                ),
                                Text('Completions'),
                                SizedBox(
                                  height: 15,
                                ),
                                Text('$reachedGoals',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.today,
                                  color: Colors.blue,
                                  size: 40.0,
                                ),
                                Text('Avarage'),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  '$averageIntake mL',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        });
  }
}
