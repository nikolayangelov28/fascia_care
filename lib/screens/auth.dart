import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fascia_care/main.dart';
import 'package:fascia_care/service/databaseService.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/screens/home.dart';
import 'package:fascia_care/service/sharedPreferences.dart';
import 'package:fascia_care/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final DatabaseService databaseService = DatabaseService();
  final LocalSharedPreferences sharedPreferences = LocalSharedPreferences();
  final String year = DateTime.now().year.toString();
  final String month = DateTime.now().month.toString();
  final int thisDay = DateTime.now().day;
  var _isLoading = false;
  final List lastSevenDays = [0, 0, 0, 0, 0, 0, 0];

  ProfileService waterService = ProfileService();
  String waterIntakeString;

  Future waterIntakeCalc(String gender, int age, double weight) async {
    var waterIntake;
    int waterIntakeRounded;
    var ageImpact;
    var pounds = weight * 2.205;

    // age impact at different ages
    if (age < 30) {
      ageImpact = 40;
    } else if (age <= 55 && age >= 30) {
      ageImpact = 35;
    } else {
      ageImpact = 30;
    }
    // water intake in pounds
    waterIntake = (((pounds / 2.2) * ageImpact) / 28.3);
    // water intake in liters
    waterIntake = waterIntake / 33.8;
    if (gender == 'Male') {
      // water intake in milliliters rounded
      waterIntakeRounded = (waterIntake * 1000).round();
      waterIntakeString = waterIntakeRounded.toString();
    } else if (gender == 'Female') {
      // water intake in milliliters rounded
      waterIntakeRounded = ((waterIntake * 1000) - 546).round();
      waterIntakeString = waterIntakeRounded.toString();
    } else if (gender == 'Other') {
      // water intake in milliliters
      waterIntakeRounded = ((waterIntake * 1000) - 373).round();
      waterIntakeString = waterIntakeRounded.toString();
    } else {
      AlertDialog(
        title: const Icon(Icons.broken_image_sharp),
        content:
            const Text('Something with the calculation went wrong. Try again!'),
        actions: [ElevatedButton(onPressed: () {}, child: Text('okay'))],
      );
      return 0;
    }
    return waterIntakeRounded;
  }

  void _submitAuthForm(String email, String password, String gender, int age,
      double weight, BuildContext ctx) async {
    UserCredential userCredential;
    setState(() {
      _isLoading = true;
    });
    await waterIntakeCalc(gender, age, weight).then((_) async {
      try {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        var userUid = userCredential.user.uid;
        await databaseService
            .setProfileStructure(
                userUid, email, age, gender, weight, waterIntakeString)
            .then((_) async {
          profileService.uid = userCredential.user.uid;
          profileService.age = age;
          profileService.weight = weight;
          profileService.email = email;
          profileService.gender = gender;
          profileService.waterIntake = waterIntakeString;
          profileService.mainWaterIntake = waterIntakeString;
          sharedPreferences
              .setLocalProfile(email, age, gender, weight, waterIntakeString)
              .then((_) async {
            await databaseService
                .setWeeklyAchievementStructure(userUid)
                .then((_) async {
              await databaseService
                  .setYearCollection(userCredential.user.uid)
                  .then((_) async {
                await databaseService
                    .setMonthCollection(userCredential.user.uid)
                    .then((_) async {
                  await databaseService.setYearDataStructure().then((_) async {
                    await databaseService
                        .setMonthDataStructure()
                        .then((_) async {
                      await sharedPreferences
                          .setDay(thisDay.toString())
                          .then((_) {
                        Navigator.pop(ctx);
                        Navigator.of(ctx)
                            .pushReplacement(MaterialPageRoute(builder: (ctx) {
                          return HomeScreen();
                        }));
                      });
                    });
                  });
                });
              });
            });
          });
        });
        // await databaseService.setProfileStructure(userCredential.user.uid, email, age, gender, weight, (waterIntake).toString());
        // sharedPreferences.setLocalProfile(email, age, gender, weight, (waterIntake).toString());
/*    await databaseService.setWeeklyAchievementStructure(userCredential.user.uid);
      await databaseService.setYearCollection(userCredential.user.uid);
      await databaseService.setMonthCollection(userCredential.user.uid);
      await databaseService.setYearDataStructure();
      await databaseService.setMonthDataStructure(); */
      } on FirebaseAuthException catch (e) {
        var message = e.toString();
        if (e.code == 'email-already-exists') {
          message = 'The provided email is already used!';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        }
        ScaffoldMessenger.of(ctx)
            .showSnackBar(SnackBar(content: Text(message)));
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          shadowColor: Colors.transparent,
          //title: Text('Sign up'),
        ),
        // backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, _isLoading));
  }
}
