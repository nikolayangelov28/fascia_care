import 'package:fascia_care/main.dart';
import 'package:flutter/material.dart';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
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
  String activityLevelText = '';
  String intakeIncrease = '';

  void activityChange(int newActivityLevel) {
    setState(() {
      switch (newActivityLevel) {
        case 1:
          // less than 30 min activity
          profileService.activityLevel = newActivityLevel;
          activityLevelText = 'Sedentary';
          intakeIncrease = '0mL';
          break;
        case 2:
          profileService.activityLevel = newActivityLevel;
          activityLevelText = 'Lightly active';
          intakeIncrease = '495mL';
          var newIntake = int.parse(profileService.waterIntake) + 495;
          profileService.waterIntake = newIntake.toString();
          break;
        case 3:
          profileService.activityLevel = newActivityLevel;
          activityLevelText = 'Modernate active';
          intakeIncrease = '825mL';
          var newIntake = int.parse(profileService.waterIntake) + 825;
          profileService.waterIntake = newIntake.toString();
          break;
        case 4:
          profileService.activityLevel = newActivityLevel;
          activityLevelText = 'Very active';
          intakeIncrease = '1.33L';
          var newIntake = int.parse(profileService.waterIntake) + 1330;
          profileService.waterIntake = newIntake.toString();
          break;
        default:
          activityLevelText = 'error';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print('Activity');
    // getActivityText();
    activityChange(profileService.activityLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              Container(
                child:
                    Text('+' + intakeIncrease, style: TextStyle(fontSize: 15)),
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
                          icon: (profileService.activityLevel == 1)
                              ? const Icon(Icons.looks_one, size: 40)
                              : const Icon(
                                  Icons.looks_one_outlined,
                                  size: 40,
                                ),
                          color: (profileService.activityLevel == 1)
                              ? Colors.green
                              : Colors.grey[700],
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(snackBar)
                          },
                        ),
                        onLongPress: () => {activityChange(1)}),
                    SizedBox(width: 10),
                    GestureDetector(
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 15,
                          splashColor: Colors.green,
                          icon: (profileService.activityLevel == 2)
                              ? const Icon(Icons.looks_two, size: 40)
                              : const Icon(
                                  Icons.looks_two_outlined,
                                  size: 40,
                                ),
                          color: (profileService.activityLevel == 2)
                              ? Colors.green
                              : Colors.grey[700],
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(snackBar)
                          },
                        ),
                        onLongPress: () => {activityChange(2)}),
                    SizedBox(width: 10),
                    GestureDetector(
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 15,
                          splashColor: Colors.green,
                          icon: (profileService.activityLevel == 3)
                              ? const Icon(Icons.looks_3, size: 40)
                              : const Icon(
                                  Icons.looks_3_outlined,
                                  size: 40,
                                ),
                          color: (profileService.activityLevel == 3)
                              ? Colors.green
                              : Colors.grey[700],
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(snackBar)
                          },
                        ),
                        onLongPress: () => {activityChange(3)}),
                    SizedBox(width: 10),
                    GestureDetector(
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 15,
                          splashColor: Colors.green,
                          icon: (profileService.activityLevel == 4)
                              ? const Icon(Icons.looks_4, size: 40)
                              : const Icon(
                                  Icons.looks_4_outlined,
                                  size: 40,
                                ),
                          color: (profileService.activityLevel == 4)
                              ? Colors.green
                              : Colors.grey[700],
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(snackBar)
                          },
                        ),
                        onLongPress: () => {activityChange(4)}),
                  ],
                )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(activityLevelText,
                    style:
                        TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
