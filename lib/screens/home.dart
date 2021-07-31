import 'package:fascia_care/screens/dashboard.dart';
import 'package:fascia_care/screens/settings.dart';
import 'package:fascia_care/screens/videos.dart';
import 'package:fascia_care/service/activityService.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/service/sharedPreferences.dart';
import 'package:fascia_care/service/weatherService.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileService profileService = ProfileService();
  final LocalSharedPreferences sharedPreferences = LocalSharedPreferences();
  final ActivityService activityService = ActivityService();
  final WeatherService weatherService = WeatherService();
  final List<Widget> _children = [Dashboard(), Videos(), SettingsScreen()];
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedIconTheme: IconThemeData(size: 30, opacity: 1),
        unselectedIconTheme: IconThemeData(size: 25, opacity: 1),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_collection), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
