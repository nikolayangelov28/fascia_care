import 'package:connectivity/connectivity.dart';
import 'package:fascia_care/screens/home.dart';
import 'package:fascia_care/screens/start.dart';
import 'package:fascia_care/service/notificationService.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/service/sharedPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final ProfileService profileService = ProfileService();
final LocalSharedPreferences sharedPreferences = LocalSharedPreferences();
var isInternetConnection;
var isUserLogged;
final int thisMonth = DateTime.now().month;
final int thisDay = DateTime.now().day;
var storedMonth;
var storedDay;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  await LocalSharedPreferences().init();
  runApp(MyApp());
  checkInternetConnection();
}

Future<bool> checkInternetConnection() async {
  checkUserState().then((value) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      isInternetConnection = true;
      profileService.isInternet = true;
    } else {
      isInternetConnection = false;
      profileService.isInternet = false;
    }
  });
  return isInternetConnection;
}

Future<bool> checkUserState() async {
  if (FirebaseAuth.instance.currentUser == null) {
    isUserLogged = false;
    return isUserLogged;
  } else {
    isUserLogged = true;
    return isUserLogged;
  }
}

Future checkDay() async {
    await sharedPreferences.getDay().then((value) async => {
      storedDay = value
    }).then((value) async => {
      if (storedDay == (thisDay.toString())){
       await sharedPreferences.getLocalData()
      } else {
        await sharedPreferences.setWaterIntake('0').then((value) async => {
          await sharedPreferences.setDailyWaterIntake('0').then((value) async => {
            await sharedPreferences.setDailyIntakeProgress(0.0).then((value) async => {
              await sharedPreferences.setDailyIntakePercent('0').then((value) async => {
                await sharedPreferences.getLocalData()
              })
            })
          })
        })
      }
    });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: FutureBuilder(
        future: checkInternetConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (isUserLogged == false) {
            print('User is NOT logged in');
            // user not logged in
            return Start();
            // user is logged in
          } else if (isUserLogged == true) {
            return FutureBuilder(
                future: checkDay(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue)));
                  } else if (snapshot.hasError) {
                  } else {
                    // load from local
                    print('user is loged and local data is loaded');
                    return HomeScreen();
                  }
                });
          }
        },
      ),
    );
  }
}
