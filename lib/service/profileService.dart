import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfileService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection('users');
  static final ProfileService _instance = ProfileService.internal();

  factory ProfileService() => _instance;

  ProfileService.internal() {
    waterIntake = '0';
    dailyWaterIntake = '0';
    waterCup = '140';
    activityLevel = 1;
    activityIncreaseValue = '0mL';
    activityLevelText = 'Sedentary';
    mainWaterIntake = '0';
    dailyIntakePercent = '0';
    dailyIntakeProgress = 0.0;
    firstLogToday = false;
    weatherText = 'Normal';
    weatherTemp = 20.0;
    weatherIntakeIncrease = '0mL';
    waterCupIndex = 1;
    firstLocalFetch = 0;
    isNotification = false;
    notificationMode = 'Daily';
    age = 0;
    weight = 0;
    email= '';
  }

  // water values
  String mainWaterIntake;
  String waterIntake;
  String dailyWaterIntake;
  String waterCup;
  String dailyIntakePercent;
  double dailyIntakeProgress;
  var lastSevenDays = ['false', 'false', 'false', 'false', 'false', 'false', 'false'];
  int waterCupIndex;


  // activity values
  int activityLevel;
  String activityIncreaseValue;
  String activityLevelText;

  // weather values
  String weatherText;
  String weatherIntakeIncrease;
  double weatherTemp;

  bool isInternet;
  bool firstLogToday;
  List<FlSpot> monthChartList = [];
  int firstLocalFetch;

  //Profile info
  int age;
  double weight;
  String gender;
  String email;
  String uid;
  bool isNotification;
  String notificationMode;
}