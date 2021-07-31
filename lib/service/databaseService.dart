import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final User user = auth.currentUser;
final int thisYear = DateTime.now().year;
final int thisMonth = DateTime.now().month;
final int thisDay = DateTime.now().day;
List dataList = [];
final FirebaseAuth auth = FirebaseAuth.instance;
final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
final CollectionReference yearCollection =
    FirebaseFirestore.instance.collection('users/${user.uid}/$thisYear/');
final CollectionReference currMonthDaysCollection = FirebaseFirestore.instance
    .collection('users/${user.uid}/$thisYear/$thisMonth/days/');

class DatabaseService {
  Map testMonthData;
  var monthSnapshot;
  var yearSnapshot;
  var weekSnapshot;

  var monthData;
  var yearData;
  var currDayData;
  var weeklyAchieve;

  var yearDataGoals;
  var userData;
  var intakeDaysMap = [];
  var intakeDays;
  var dayIntake;
  var intakeValuesMap = [];
  Map<String, Map<String, Object>> monthMap = {};
  Map<String, Map<String, int>> yearMap = {};

/*  UPDATE  DATA FROM DATABASE */

  Future updateWeeklyAchievement(List weekAchieve) async {
    await userCollection
        .doc('${user.uid}')
        .update({'weeklyAchieve': weeklyAchieve});
  }

  Future updateDailyIntake(int intake) {
    return userCollection
        .doc('${user.uid}')
        .update({'dailyWaterIntake': intake})
        .then((value) => print('Intake updated'))
        .catchError((error) => print(error));
  }

  // update current day in current month and year
  Future updateCurrDayMonthYear(
      int intake, bool goal, int monthItake, int monthGoals) async {
    await yearCollection.doc('$thisMonth').update({
      '$thisDay': {'intake': intake, 'goalReached': goal}
    }).then((_) async => {
          await yearCollection.doc('$thisYear').update({
            '$thisMonth': {'intake': monthItake, 'goalsReached': monthGoals}
          })
        });
  }

  Future updateCurrDayYear(int intake, int goals) {
    return yearCollection
        .doc('$thisYear')
        .update({
          '$thisMonth': {'intake': intake, 'goalReached': goals}
        })
        .then((value) => print('monthly intake updated'))
        .catchError((error) => print('Failed to update monthly intake'));
  }

  /*  GET DATA FROM DATABASE */

  Future getWeeklyAchievement() async {
    weekSnapshot = await userCollection.doc('${user.uid}').get();
    weeklyAchieve = weekSnapshot.data()['weeklyAchieve'];
    return weeklyAchieve;
  }

  // get the the current day map from the month document -> {goalReached: true, intake: 2311}
  Future getCurrDayData() async {
    monthSnapshot = await yearCollection.doc('$thisMonth').get();
    currDayData = monthSnapshot.data()['$thisDay'];
    return currDayData;
  }

  // get whole fields from currentmonth and set them to variable
  Future getMonthData() async {
    monthSnapshot = await yearCollection.doc('$thisMonth').get();
    monthData = monthSnapshot;
    return monthData;
  }

  // get whole fields from current year and set them to variable
  Future getYearData() async {
    yearSnapshot = await yearCollection.doc('$thisYear').get();
    yearData = yearSnapshot;
    return yearData;
  }

  /* STRUCTURES FOR THE DATABASE */

  Future setProfileStructure(userUid, email, age, gender, weight, waterIntake) async {
    await userCollection
        .doc(userUid)
        .set({
        'email': email,
        'gender': gender,
        'age': age,
        'weight': weight,
        'waterIntake': waterIntake,
        'dailyWaterIntake': 0,
        'activityLevel': 1,
        'weatherLevel': 'normal',
        'cup': '140'
      })
        .then((value) => print('structure set'))
        .catchError((error) => print('Failed to set structure'));
  }

  // weekly achievement
  Future setWeeklyAchievementStructure(uid) async {
    await userCollection.doc(uid).update({
      'weeklyAchieve': [false, false, false, false, false, false, false]
    });
  }

  // month db structure
  Future setMonthDataStructure() async {
    for (int i = 1; i <= 31; i++) {
      await yearCollection
          .doc('$thisMonth')
          .update({
            '$i': {'intake': 0, 'goalReached': false}
          })
          .then((value) => print('structure set'))
          .catchError((error) => print('Failed to set structure'));
    }
  }

  // year db structure
  Future setYearDataStructure() async {
    for (int i = 1; i <= 12; i++) {
      await yearCollection
          .doc('$thisYear')
          .update({
            '$i': {'intake': 0, 'goalsReached': 0}
          })
          .then((value) => print('structure set'))
          .catchError((error) => print('Failed to set structure'));
    }
  }

  Future setYearCollection(uid) async{
    await userCollection.doc(uid).collection('$thisYear').doc('$thisYear').set({});
  }
    Future setMonthCollection(uid) async{
    await userCollection.doc(uid).collection('$thisYear').doc('$thisMonth').set({});
  }
}
