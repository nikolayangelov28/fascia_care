import 'package:fascia_care/main.dart';
import 'package:fascia_care/screens/start.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/service/sharedPreferences.dart';
import 'package:fascia_care/widgets/age-modal.dart';
import 'package:fascia_care/widgets/gender-modal.dart';
import 'package:fascia_care/widgets/weight-modal.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fascia_care/service/notificationService.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

notificationSnackBar(String val, String period) => SnackBar(
      content: Row(
        children: [
          period == 'Hourly'
              ? Text('Hourly notifications are turned $val.')
              : Text('Daily notifications are turned $val.'),
          Icon(
            val == 'off' ? Icons.notifications_off : Icons.notifications_on,
            color: val == 'off' ? Colors.grey[850] : Colors.amber,
          )
        ],
      ),
      duration: Duration(milliseconds: 1000),
    );

class _SettingsScreenState extends State<SettingsScreen> {
  final ProfileService profileService = ProfileService();
  final NotificationService notificationService = NotificationService();
  final LocalSharedPreferences sharedPreferences = LocalSharedPreferences();
  final appBar = AppBar(
    title: Text('Settings'),
    centerTitle: true,
  );

  bool isSwitchedOn = false;
  String _notificationRadioBtnVal = 'Hourly';

  void onLogOut(ctx) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm logout'),
        content: const Text('Are you sure you want to logout'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel',
                style: TextStyle(
                  color: Colors.amber,
                )),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().catchError((err) => {print(err)});
              Navigator.of(ctx)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return Start();
              }));
            },
            child: const Text('OK',
                style: TextStyle(
                  color: Colors.amber,
                )),
          ),
        ],
      ),
    );
  }

  void handleNotifications(bool isNotification) {
    isSwitchedOn = isNotification;
    if (isNotification == true) {
      var newValue = 'on';
      profileService.isNotification = true;
      sharedPreferences.setNotification(true);
      //set notification
      ScaffoldMessenger.of(context).showSnackBar(
          notificationSnackBar(newValue, profileService.notificationMode));
    } else {
      var newValue = 'off';
      profileService.isNotification = false;
      sharedPreferences.setNotification(false);
      notificationService.stopNotification().then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            notificationSnackBar(newValue, profileService.notificationMode));
      });
    }
  }

  void handleNotificationSelection(value) {
    profileService.notificationMode = value;
    // start notification
    if (profileService.isNotification == true) {
      var newValue = 'on';
      notificationService.stopNotification().then((value) => {
            if (profileService.notificationMode == 'Hourly')
              {
                profileService.notificationMode = 'Hourly',
                sharedPreferences.setNotificationMode('Hourly'),
                notificationService
                    .scheduleHourlyNotification()
                    .then((value) => {
                          ScaffoldMessenger.of(context).showSnackBar(
                              notificationSnackBar(
                                  newValue, profileService.notificationMode))
                        })
              }
            else if (profileService.notificationMode == 'Daily')
              {
                profileService.notificationMode = 'Daily',
                sharedPreferences.setNotificationMode('Daily'),
                notificationService
                    .scheduleHourlyNotification()
                    .then((value) => {
                          ScaffoldMessenger.of(context).showSnackBar(
                              notificationSnackBar(
                                  newValue, profileService.notificationMode))
                        })
              }
          });
    }
  }

  _mediaQueryHeight(BuildContext ctx) => (MediaQuery.of(ctx).size.height -
      appBar.preferredSize.height -
      MediaQuery.of(ctx).padding.top -
      MediaQuery.of(ctx).padding.bottom);

  _mediaQueryWidth(ctx) => (MediaQuery.of(context).size.width * 1);

Future getProfileInfo() async {
  await sharedPreferences.getEmail().then((value) => {
    profileService.email = value
  }).then((value) async => {
    await sharedPreferences.getAge().then((value) => {
      profileService.age = value
    }).then((value) async => {
      await sharedPreferences.getGender().then((value) => {
        profileService.gender = value
      }).then((value) async  => {
        await sharedPreferences.getWeigth().then((value) => {
          profileService.weight = value
        })

      })
    })
  });
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileInfo().then((value) {
      setState(() {
        print('data updated');
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(
                right: 30,
                left: 30,
              ),
              height: _mediaQueryHeight(context) * 0.1,
              width: _mediaQueryWidth(context),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.amber,
                      size: 50.0,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${profileService.email}'),
                  ],
                ),
              ]),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 15, right: 30, left: 30, bottom: 5),
              width: _mediaQueryWidth(context),
              child: Text(
                'Profile',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Material(
              child: Container(
                color: Colors.transparent,
                height: _mediaQueryHeight(context) * 0.3,
                width: _mediaQueryWidth(context),
                padding: const EdgeInsets.only(
                    top: 5, right: 15, left: 15, bottom: 15),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [GenderModal(context, appBar)]),
                    Container(
                      height: 1,
                      width: (_mediaQueryWidth(context) - 30) * 1,
                      color: Colors.grey,
                    ),
                    Row(children: [
                      WeightModal(context, appBar),
                    ]),
                    Container(
                      height: 1,
                      width: (_mediaQueryWidth(context) - 30) * 1,
                      color: Colors.grey,
                    ),
                    Row(children: [AgeModal(context, appBar)])
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 15, right: 30, left: 30, bottom: 0),
              width: _mediaQueryWidth(context),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Switch(
                            value: profileService.isNotification,
                            activeColor: Colors.amber,
                            activeTrackColor: Colors.amber[300],
                            onChanged: (value) {
                              setState(() {
                                handleNotifications(value);
                              });
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: _mediaQueryHeight(context) * 0.2,
              width: _mediaQueryWidth(context),
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
              child: Column(
                children: [
                  Row(children: [
                    Container(
                      child: Ink(
                        padding: const EdgeInsets.all(15),
                        height: (_mediaQueryHeight(context) - 15) * 0.08,
                        width: (_mediaQueryWidth(context) - 30) * 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                          color: Colors.grey[900],
                        ),
                        child: Row(
                          children: [
                            Container(
                                width: 80,
                                margin: const EdgeInsets.only(left: 5),
                                child: Text('every hour')),
                            Radio(
                                value: 'Hourly',
                                activeColor: profileService.isNotification == true
                                    ? Colors.amber
                                    : Colors.grey,
                                groupValue: profileService.notificationMode,
                                onChanged: (value) {
                                  setState(() {
                                    handleNotificationSelection(value);
                                  });
                                }),
                          ],
                        ),
                      ),
                    ),
                  ]),
                  Container(
                    height: 1,
                    width: (MediaQuery.of(context).size.width - 30) * 1,
                    color: Colors.grey,
                  ),
                  Row(children: [
                    Container(
                      child: Ink(
                        height: (_mediaQueryHeight(context) - 15) * 0.08,
                        width: (_mediaQueryWidth(context) - 30) * 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          color: Colors.grey[900],
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 5),
                                width: 80,
                                child: Text('every day')),
                            Radio(
                                value: 'Daily',
                                activeColor: profileService.isNotification == true
                                    ? Colors.amber
                                    : Colors.grey,
                                groupValue: profileService.notificationMode,
                                onChanged: (value) {
                                  setState(() {
                                    handleNotificationSelection(value);
                                  });
                                }),
                          ],
                        ),
                      ),
                    )
                  ]),
                ],
              ),
            ),
            Container(
              child: SizedBox(
                width: 80,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      onLogOut(context);
                    },
                    child: Text('Log out',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2.0,
                                  color: Color.fromARGB(255, 0, 0, 0))
                            ]))),
              ),
            ),
            Expanded(
                child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey[700],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Version: 1.0'),
                ],
              ),
            )),
            SizedBox(height: 5)
          ],
        ));
  }
}
