import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/service/sharedPreferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final ProfileService profileService = ProfileService();
  final LocalSharedPreferences sharedPreferences = LocalSharedPreferences();
  var dailyIntakePercent;
  var dailyIntakeProgress;
  var newIntake;
  bool serviceEnabled;
  LocationPermission permission;
  String lat = '';
  String long = '';
  // String latitude = '49.992863';
  // String longitude = '8.247253';

  Future getCurrentLocation() async {
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium)
        .then((value) async {
      lat = '${value.latitude}';
      long = '${value.longitude}';
      print(lat);
      print(long);
    }).then((value) async {
      await fetchWeather(lat, long);
    });
  }

  Future<void> fetchWeather(lat, long) async {
    final String apiKey = 'fd82b1c6daf9c43c485d5ab9e44f3c93';
    var response;
    final requestURL =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&units=metric&appid=$apiKey';

    response = await http.get(Uri.parse(requestURL));
    if (response.statusCode == 200) {
      Map valueMap = jsonDecode(response.body);
      var temp = (valueMap['main']['temp']).round();
      await sharedPreferences.getMainWaterIntake().then((value) async {
        profileService.mainWaterIntake = value;
      }).then((value) {
        if (temp >= 30) {
          print('hot');
          profileService.weatherText = 'Hot';
          newIntake = ((int.parse(profileService.mainWaterIntake) * 0.015) * 10)
              .round();
          profileService.weatherIntakeIncrease = newIntake.toString() + 'mL';
          profileService.waterIntake =
              (int.parse(profileService.waterIntake) + newIntake).toString();
        } else if (temp <= 29 && temp >= 24) {
          print('warm');
          profileService.weatherText = 'Warm';
          newIntake =
              ((int.parse(profileService.mainWaterIntake) * 0.015) * 5).round();
          profileService.weatherIntakeIncrease = newIntake.toString() + 'mL';
          profileService.waterIntake =
              (int.parse(profileService.waterIntake) + newIntake).toString();
        } else if (temp <= 23 && temp > 17) {
          print('normal');
          profileService.weatherText = 'Normal';
          profileService.weatherIntakeIncrease = '0mL';
          profileService.waterIntake = profileService.mainWaterIntake;
        } else if (temp <= 17 && temp > 10) {
          print('cool');
          profileService.weatherText = 'Cool';
          newIntake =
              ((int.parse(profileService.mainWaterIntake) * 0.01) * 5).round();
          profileService.weatherIntakeIncrease = newIntake.toString() + 'mL';
          profileService.waterIntake =
              (int.parse(profileService.waterIntake) + newIntake).toString();
        }
      });
    }
  }
}
