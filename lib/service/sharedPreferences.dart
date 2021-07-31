import 'package:fascia_care/service/profileService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSharedPreferences {
  static SharedPreferences _preferences;
  final ProfileService profileService = ProfileService();
  final int thisYear = DateTime.now().year;
  final int thisMonth = DateTime.now().month;
  final int thisDay = DateTime.now().day;

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /* WATER INTAKE */
  Future setWaterIntake(String intake) async {
    await _preferences.setString('waterIntake', intake);
  }

  Future setMainWaterIntake(String mainIntake) async {
    await _preferences.setString('mainWaterIntake', mainIntake);
  }

  Future getWaterIntake() async {
    return _preferences.getString('waterIntake');
  }

  Future getMainWaterIntake() async {
    return _preferences.getString('mainWaterIntake');
  }

  /* DAILY WATER INTAKE */
  Future setDailyWaterIntake(String dailyIntake) async {
    await _preferences.setString('dailyWaterIntake', dailyIntake);
  }

  Future test() async {
    await _preferences.remove('waterIntake');
  }

  Future getDailyWaterIntake() async {
    return _preferences.getString('dailyWaterIntake');
  }

  /* DAILY WATER PERCENT */
  Future setDailyIntakePercent(String intakePercent) async {
    await _preferences.setString('dailyIntakePercent', intakePercent);
  }

  Future getDailyIntakePercent() async {
    return _preferences.getString('dailyIntakePercent');
  }

  /* DAILY WATER PROGRESS */
  Future setDailyIntakeProgress(double intakeProgress) async {
    await _preferences.setDouble('dailyIntakeProgress', intakeProgress);
  }

  Future getDailyIntakeProgress() async {
    return _preferences.getDouble('dailyIntakeProgress');
  }

  /*WATER CUP*/
  Future setWaterCup(String waterCup) async {
    await _preferences.setString('waterCup', waterCup);
  }

  Future getWaterCup() async {
    return _preferences.getString('waterCup');
  }

  /* ACTIVITY LEVEL */
  Future setActivity(int activityLevel) async {
    await _preferences.setInt('activityLevel', activityLevel);
  }

  Future getActivityLevel() async {
    return _preferences.getInt('activityLevel');
  }

  /* WEATHER LEVEL */
  Future setWeatherLevel(double weatherLevel) async {
    await _preferences.setDouble('weatherLevel', weatherLevel);
  }

  Future getWeatherLevel() async {
    return _preferences.getDouble('weatherLevel');
  }

  // profile info
  Future setNewWeigth(double weight) async {
    await _preferences.setDouble('weigth', weight);
  }

  Future setNewGender(String gender) async {
    await _preferences.setString('gender', gender);
  }

  Future getNotification() async {
    return _preferences.getBool('isNotification');
  }

  Future setNotification(bool notification) async {
    await _preferences.setBool('isNotification', notification);
  }

  Future getNotificationMode() async {
    return _preferences.getString('notificationMode');
  }

  Future setNotificationMode(String notificationMode) async {
    await _preferences.setString('notificationMode', notificationMode);
  }

  Future getEmail() async {
    return _preferences.getString('email');
  }

  Future getGender() async {
    return _preferences.getString('gender');
  }

  Future getAge() async {
    return _preferences.getInt('age');
  }

  Future getWeigth() async {
    return _preferences.getDouble('weight');
  }

  // Daily comparison
  Future setMonth(thisMonth) async {
    await _preferences.setString('thisMonth', thisMonth.toString());
  }
    Future getMonth() async {
    return _preferences.getString('thisMonth');
  }

  Future setDay(thisDay) async {
    await _preferences.setString('thisDay', thisDay.toString());
  }
  
  Future getDay() async {
    return _preferences.getString('thisDay');
  }

  Future setLocalProfile(String email, int age, String gender, double weight,
      String waterIntake) async {
    await _preferences.setString('email', email).then((_) async {
      await _preferences.setString('gender', gender).then((_) async {
        await _preferences.setInt('age', age).then((_) async {
          await _preferences.setDouble('weight', weight).then((value) async {
            await _preferences
                .setString('waterIntake', waterIntake)
                .then((value) async {
              await _preferences
                  .setString('dailyWaterIntake', '0')
                  .then((value) async {
                await _preferences
                    .setInt('activityLevel', 1)
                    .then((value) async {
                  await _preferences
                      .setDouble('weatherLevel', 20.0)
                      .then((value) async {
                    await _preferences
                        .setString('waterCup', '140')
                        .then((value) async {
                      await _preferences
                          .setString('dailyIntakePercent', '0')
                          .then((value) async {
                        await _preferences
                            .setDouble('dailyIntakeProgress', 0.0)
                            .then((value) async {
                          await _preferences
                              .setString('mainWaterIntake', waterIntake)
                              .then((value) async {
                            await _preferences.setBool('isNotification', false);
                          }).then((value) async {
                            await _preferences.setString(
                                'notificationMode', 'Daily');
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  Future getLocalData() async {
    await getWaterIntake()
        .then((value) async => {
              profileService.waterIntake = value,
            })
        .then((_) async => {
              await getDailyWaterIntake()
                  .then((value) async => {
                        profileService.dailyWaterIntake = value,
                      })
                  .then((value) async => {
                        await getDailyIntakeProgress()
                            .then((value) async => {
                                  profileService.dailyIntakeProgress = value,
                                })
                            .then((value) async => {
                                  await getDailyIntakePercent()
                                      .then((value) async => {
                                            profileService.dailyIntakePercent =
                                                value,
                                          })
                                      .then((value) async => {
                                            await getActivityLevel()
                                                .then((value) async => {
                                                      profileService
                                                              .activityLevel =
                                                          value,
                                                    })
                                                .then((value) async => {
                                                      await getWaterCup()
                                                          .then(
                                                              (value) async => {
                                                                    profileService
                                                                            .waterCup =
                                                                        value,
                                                                  })
                                                          .then(
                                                              (value) async => {
                                                                    await getWeatherLevel()
                                                                        .then((value) async =>
                                                                            {
                                                                              profileService.weatherTemp = value,
                                                                            })
                                                                        .then((value) async =>
                                                                            {
                                                                              await getNotification()
                                                                                  .then((value) async => {
                                                                                        profileService.isNotification = value
                                                                                      })
                                                                                  .then((value) async => {
                                                                                        await getNotificationMode().then((value) {
                                                                                          profileService.notificationMode = value;
                                                                                        }).then((value) async => {
                                                                                              await getEmail().then((value) => {profileService.email, print('email'), print(value)}).then((value) async => {
                                                                                                    await getAge().then((value) => {profileService.age, print('age'), print(value)}).then((value) async => {
                                                                                                          await getGender().then((value) async => {profileService.gender = value}).then((value) async => {
                                                                                                                await getWeigth().then((value) => {profileService.weight = value})
                                                                                                              })
                                                                                                        })
                                                                                                  })
                                                                                            })
                                                                                      })
                                                                            })
                                                                  })
                                                    })
                                          })
                                })
                      })
            });
  }
}
