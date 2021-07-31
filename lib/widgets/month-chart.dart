import 'package:fascia_care/screens/water-screen-charts.dart';
import 'package:fascia_care/service/databaseService.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/widgets/chart-goal-line.dart';
import 'package:fascia_care/widgets/month-chart-title.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthChart extends StatefulWidget {
  @override
  _MonthChartState createState() => _MonthChartState();
}

class _MonthChartState extends State<MonthChart>
    with AutomaticKeepAliveClientMixin {
  final List<Color> gradientColors = [
    const Color(0xff2196f3),
  ];
  final DatabaseService databaseService = DatabaseService();
  final ProfileService profileService = ProfileService();
  List<FlSpot> monthChartList = [];
  FlSpot chartDot;
  int reachedGoals = 0;
  int intakeSum = 0;
  String intakeSumString = '0';
  int averageIntake = 0;

  // get data and create whole chart with the external info
  Future createChart() async {
    await setData().then((value) async => {
          intakeSumString = (intakeSum / 1000).toStringAsFixed(2),
          averageIntake = (intakeSum / 31).round()
        });
  }

  Future setData() async {
    var intake;
    var goal;
    await databaseService.getMonthData().then((value) => {
          for (int i = 1; i <= 31; i++)
            {
              intake = value.data()['$i']['intake'],
              goal = value.data()['$i']['goalReached'],
              intakeSum = (intakeSum + intake),
              chartDot = FlSpot(((i - 1).toDouble()), intake.toDouble()),
              monthChartList.add(chartDot),
              profileService.monthChartList.add(chartDot),
              if (goal == true) {reachedGoals = reachedGoals + 1}
            }
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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
                  Text('Month Chart'),
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
                    child: LineChart(
                      LineChartData(
                        extraLinesData: GoalLine.getGoalLine(),
                        minX: 0,
                        maxX: 30,
                        minY: 0,
                        maxY: 5000,
                        titlesData: LineTitleMonth.getTitleData(),
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
                            spots: monthChartList,
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
                      ),
                    ),
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
