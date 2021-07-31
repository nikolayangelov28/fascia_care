import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  final appBar = AppBar(
    title: Text('Activity'),
    elevation: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        body: Container(
          color: Colors.grey[900],
          height: (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
              1,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            children: [
              //level 1
              Container(
                margin: EdgeInsets.only(top: 40),
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) *
                    0.15,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.looks_one,
                          size: 40,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('1. Sedentary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('Typicaly daily activities refering to people\'s self-care (e.g. bathing, dressing, sleeping).', style: TextStyle(color: Colors.white60))
                              ],
                            )
                            )
                      ],
                    ),
                  ],
                ),
              ),
              //level 2
              Container(
                margin: EdgeInsets.only(top: 5),
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) *
                    0.15,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.looks_two,
                          size: 40,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                      Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('2. Somewhat active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('Typicaly daily activities and 30-60 minutes of daily'
                                'moderate activity.', style: TextStyle(color: Colors.white60))
                              ],
                            )
                            )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) *
                    0.15,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.looks_3,
                          size: 40,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                          Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('3. Modernate active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('Typicaly daily activities plus at least 60 minutes of daily'
                                'moderate activity.', style: TextStyle(color: Colors.white60))
                              ],
                            )
                            )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) *
                    0.15,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.looks_4,
                          size: 40,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.7,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('4. Very active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('At least 60 minutes of daily moderate activity plus'
                                '60 minutes (or more) ofvigorous activity.', style: TextStyle(color: Colors.white60))
                              ],
                            )
                            )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
