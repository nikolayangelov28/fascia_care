
import 'dart:async';

import 'package:fascia_care/screens/home.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/widgets/auth/auth_login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fascia_care/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstore/localstore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final db = Localstore.instance;
  final _auth = FirebaseAuth.instance;
  ProfileService profileService = ProfileService();
  var _isLoading = false;
  String waterIntakeString = '0';

   Future <void> getUserData() async{
      final User user = auth.currentUser;
      var uid = user.uid;
      var a = await userCollection.doc(uid).get();
      var data = a.data();
      var waterIntake = (data['waterIntake']).toString();
      var dailyIntake = (data['dailyWaterIntake']).toString();
      var waterCup = (data['cup']).toString();
      profileService.waterIntake = waterIntake;
      profileService.dailyWaterIntake = dailyIntake;
      profileService.waterCup = waterCup;
  }

  setTimeout() {
    var duration = new Duration(seconds: 6);
    return new Timer(duration, route());
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute( builder: (context) {return HomeScreen();}));
  }

  void _submitLoginForm(String email, String password, BuildContext ctx) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await getUserData();
      setTimeout();
      // Navigator.of(ctx).pushReplacement(MaterialPageRoute( builder: (context) {return HomeScreen();}));
    } on FirebaseAuthException catch (e) {
      var message = e.toString();
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      ScaffoldMessenger.of(context)
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          shadowColor: Colors.transparent,
          // title: Text('Log in'),
        ),
        // backgroundColor: Theme.of(context).primaryColor,
        body: AuthLogin(_submitLoginForm, _isLoading));
  }
}
