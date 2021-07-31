import 'package:fascia_care/screens/weather-screen.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:flutter/material.dart';

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  ProfileService profileService = ProfileService();

  void onWeatherPage(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WeatherScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => {onWeatherPage(context)},
        child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.grey[900]),
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
                      Icons.thermostat_outlined,
                      color: Colors.amber,
                      size: 30.0,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('Weather',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.amber)),
                  ),
                  Container(
                    child: Text('+' + profileService.weatherIntakeIncrease,
                        style: TextStyle(fontSize: 15)),
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
                        Icon(
                          Icons.cloud,
                          size: 40,
                          color: (profileService.weatherText == 'Cool')
                              ? Colors.amber
                              : Colors.grey[700],
                        ),
                        SizedBox(width: 15),
                        Icon(
                          Icons.wb_twighlight,
                          size: 40,
                          color: (profileService.weatherText == 'Normal')
                              ? Colors.amber
                              : Colors.grey[700],
                        ),
                        SizedBox(width: 15),
                        Icon(
                          Icons.wb_sunny_outlined,
                          size: 40,
                          color: (profileService.weatherText == 'Warm')
                              ? Colors.amber
                              : Colors.grey[700],
                        ),
                        SizedBox(width: 15),
                        Icon(
                          Icons.wb_sunny,
                          size: 40,
                          color: (profileService.weatherText == 'Hot')
                              ? Colors.amber
                              : Colors.grey[700],
                        ),
                      ],
                    )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(profileService.weatherText,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
