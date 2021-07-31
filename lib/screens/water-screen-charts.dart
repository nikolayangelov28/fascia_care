import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/widgets/month-chart.dart';
import 'package:fascia_care/widgets/year-chart.dart';
import 'package:flutter/material.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'This month'),
  Tab(text: 'This year'),
];
TabBar get _tabBar => TabBar(
      tabs: [
        Tab(text: 'Month'),
        Tab(text: 'Year'),
      ],
    );
const months = [
  "Janury",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

class WaterCharts extends StatefulWidget {
  final appBar = AppBar(
    title: Text('Charts'),
    elevation: 0,
    bottom: PreferredSize(
      preferredSize: _tabBar.preferredSize,
      child: ColoredBox(
        color: Colors.grey[900],
        child: TabBar(
            indicatorPadding: EdgeInsets.all(5),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
                //border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(color: Colors.white12, blurRadius: 2.0)
                ],
                color: Colors.grey[800]),
            // indicatorColor: Colors.blue,
            indicatorWeight: 0,
            tabs: tabs),
      ),
    ),
  );

  @override
  _WaterChartsState createState() => _WaterChartsState();
}

class _WaterChartsState extends State<WaterCharts> {
  final ProfileService profileService = ProfileService();

  var yearChartFlag = true;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    // List<Widget> _children = [YearChart(), MonthChart(isDataLoaded)];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: WaterCharts().appBar,
          backgroundColor: Colors.grey[900],
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              MonthChart(),
              YearChart(),
            ],
          )

          /* FutureBuilder(
            future: getData(),
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
                  return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: 400,
                            height: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: YearChart(isDataLoaded),
                            ),
                          ),
                        ],
                      ));
                }
              }
            }), */
          ),
    );
  }
}
