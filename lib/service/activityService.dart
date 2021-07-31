import 'package:fascia_care/main.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/service/sharedPreferences.dart';

class ActivityService {
  final ProfileService profileService = ProfileService();
  final LocalSharedPreferences sharedPreferences = LocalSharedPreferences();

  Future updateLocalData() async {
    await sharedPreferences.getMainWaterIntake().then((value) async {
      sharedPreferences.setWaterIntake(value);
      await sharedPreferences
          .setDailyIntakeProgress(profileService.dailyIntakeProgress);
      await sharedPreferences
          .setDailyIntakePercent(profileService.dailyIntakePercent);
    });
  }

  Future activityChange(int newActivityLevel) async {
    switch (newActivityLevel) {
      case 1:
        // less than 30 min activity
        profileService.activityLevel = newActivityLevel;
        profileService.activityLevelText = 'Sedentary';
        profileService.activityIncreaseValue = '0mL';
        profileService.waterIntake = profileService.mainWaterIntake;
        if (double.parse(profileService.dailyWaterIntake) <
            double.parse(profileService.waterIntake)) {
          var newProgressValue =
              ((1 * double.parse(profileService.dailyWaterIntake)) /
                  double.parse(profileService.waterIntake));
          profileService.dailyIntakeProgress = newProgressValue;
          print(newProgressValue);
          profileService.dailyIntakePercent =
              ((newProgressValue * 100).round()).toString();
          // update local data
/*           sharedPreferences.setActivity(newActivityLevel).then((value) async {
            await updateLocalData();
          }); */
        }
        break;
      case 2:
        profileService.activityLevel = newActivityLevel;
        profileService.activityLevelText = 'Lightly active';
        profileService.activityIncreaseValue = '495mL';
        var newIntake = int.parse(profileService.mainWaterIntake) + 495;
        profileService.waterIntake = newIntake.toString();
        if (double.parse(profileService.dailyWaterIntake) <
            double.parse(profileService.waterIntake)) {
          var newProgressValue =
              ((1 * double.parse(profileService.dailyWaterIntake)) /
                  double.parse(profileService.waterIntake));
          profileService.dailyIntakeProgress = newProgressValue;
          print(newProgressValue);
          profileService.dailyIntakePercent =
              ((newProgressValue * 100).round()).toString();
/*           sharedPreferences.setActivity(newActivityLevel).then((value) async {
            await updateLocalData();
          }); */
        }
        break;
      case 3:
        profileService.activityLevel = newActivityLevel;
        profileService.activityLevelText = 'Modernate active';
        profileService.activityIncreaseValue = '825mL';
        var newIntake = int.parse(profileService.mainWaterIntake) + 825;
        profileService.waterIntake = newIntake.toString();
        if (double.parse(profileService.dailyWaterIntake) <
            double.parse(profileService.waterIntake)) {
          var newProgressValue =
              ((1 * double.parse(profileService.dailyWaterIntake)) /
                  double.parse(profileService.waterIntake));
          profileService.dailyIntakeProgress = newProgressValue;
          print(newProgressValue);
          profileService.dailyIntakePercent =
              ((newProgressValue * 100).round()).toString();
/*           sharedPreferences.setActivity(newActivityLevel).then((value) async {
            await updateLocalData();
          }); */
        }
        break;
      case 4:
        profileService.activityLevel = newActivityLevel;
        profileService.activityLevelText = 'Very active';
        profileService.activityIncreaseValue = '1.33L';
        var newIntake = int.parse(profileService.mainWaterIntake) + 1330;
        profileService.waterIntake = newIntake.toString();
        if (double.parse(profileService.dailyWaterIntake) >
            double.parse(profileService.waterIntake)) {
          var newProgressValue =
              ((1 * double.parse(profileService.dailyWaterIntake)) /
                  double.parse(profileService.waterIntake));
          profileService.dailyIntakeProgress = newProgressValue;
          print(newProgressValue);
          profileService.dailyIntakePercent =
              ((newProgressValue * 100).round()).toString();
/*           sharedPreferences.setActivity(newActivityLevel).then((value) async {
            await updateLocalData();
          }); */
        }
        break;
      default:
        profileService.activityLevelText = 'error';
    }
  }
}
