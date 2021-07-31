import 'package:fascia_care/screens/auth.dart';
import 'package:fascia_care/screens/login.dart';
import 'package:flutter/material.dart';

class Start extends StatelessWidget {
  void onLogin(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(
        //fullscreenDialog: true,
        builder: (context) {
      return Login();
    }));
  }

  void onSignup(BuildContext ctx) {
    Navigator.of(ctx).push(_createRoute());
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AuthScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo2.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 120),
                    child: Text('Take care of your fascia!',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontSize: 20))),
                Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.amber),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
                          onPressed: () {
                            onLogin(context);
                          },
                          child: Text('Log in',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 2.0,
                                        color: Color.fromARGB(255, 0, 0, 0))
                                  ]))),
                    )),
                SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  // margin: const EdgeInsets.only(top:100),
                  child: OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)))),
                      onPressed: () {
                        onSignup(context);
                      },
                      child: Text('Sign up', style: TextStyle(fontSize: 20))),
                )
              ],
            ),
          ),
        ));
  }
}
