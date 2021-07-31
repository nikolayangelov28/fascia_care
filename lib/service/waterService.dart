import 'package:fascia_care/service/databaseService.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/service/sharedPreferences.dart';
import 'package:localstore/localstore.dart';

class WaterService {
  final ProfileService profileService = ProfileService();
  final LocalSharedPreferences sharedPreferences = LocalSharedPreferences();
  final DatabaseService databaseService = DatabaseService();
  var newWaterIntake;
  var newProgressValue;

  Future incrementIntake() async {
    newWaterIntake = int.parse(profileService.dailyWaterIntake) +
        int.parse(profileService.waterCup);
    newProgressValue = ((1 * newWaterIntake.toDouble()) /
        double.parse(profileService.waterIntake));
    if (newWaterIntake > int.parse(profileService.waterIntake)) {
      // intake reached
      profileService.dailyIntakePercent = '100';
      profileService.dailyWaterIntake = profileService.waterIntake;
      profileService.dailyIntakeProgress = 1;
    } else {
      profileService.dailyWaterIntake = newWaterIntake.toString();
      profileService.dailyIntakeProgress = newProgressValue;
      profileService.dailyIntakePercent =
          ((newProgressValue * 100).round()).toString();
      // store new values locally
      await sharedPreferences
          .setDailyWaterIntake(profileService.dailyWaterIntake);
      await sharedPreferences
          .setDailyIntakePercent(profileService.dailyIntakePercent);
      await sharedPreferences.setDailyIntakeProgress(newProgressValue);

      //update DB weekly goals are hardcoded
      var intakeInt = int.parse(profileService.dailyWaterIntake);
      await databaseService.updateDailyIntake(intakeInt).then((value) => {
        databaseService.updateCurrDayYear(intakeInt, 0).then((value) => {
          databaseService.updateCurrDayMonthYear(intakeInt, false, intakeInt, 0)
        })
      });
    }
  }

  Future decrementIntake() async {
    newWaterIntake = int.parse(profileService.dailyWaterIntake) -
        int.parse(profileService.waterCup);
    if (newWaterIntake > 0) {
      newProgressValue = ((1 * newWaterIntake.toDouble()) /
          double.parse(profileService.waterIntake));
      profileService.dailyWaterIntake = newWaterIntake.toString();
      profileService.dailyIntakeProgress = newProgressValue;
      profileService.dailyIntakePercent =
          ((newProgressValue * 100).round()).toString();
      // store new values locally
      await sharedPreferences
          .setDailyWaterIntake(profileService.dailyWaterIntake);
      await sharedPreferences
          .setDailyIntakePercent(profileService.dailyIntakePercent);
      await sharedPreferences.setDailyIntakeProgress(newProgressValue);
    } else {
      profileService.dailyIntakePercent = '0';
      profileService.dailyWaterIntake = '0';
      profileService.dailyIntakeProgress = 0.0;
      // store new values locally
      await sharedPreferences
          .setDailyWaterIntake(profileService.dailyWaterIntake);
      await sharedPreferences
          .setDailyIntakePercent(profileService.dailyIntakePercent);
      await sharedPreferences.setDailyIntakeProgress(newProgressValue);
    }
  }

  Future changeCup(String newSize) async{
    profileService.waterCup = newSize;
    await sharedPreferences.setWaterCup(newSize);
  }
  Future<String> waterIntakeCalc(String gender, int age, double weight) async {
    var waterIntake;
    var waterIntakeRounded;
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
      profileService.waterIntake = waterIntakeRounded.toString();
    } else if (gender == 'Female') {
      // water intake in milliliters rounded
      waterIntakeRounded = ((waterIntake - 946) * 1000).round();
      profileService.waterIntake = waterIntakeRounded.toString();
    } else if (gender == 'Other') {
      // water intake in milliliters
      waterIntakeRounded = ((waterIntake - 473) * 1000).round();
      profileService.waterIntake = waterIntakeRounded.toString();
    }
  }
}
