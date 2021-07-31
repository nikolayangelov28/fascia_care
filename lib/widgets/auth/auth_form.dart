import 'package:fascia_care/main.dart';
import 'package:fascia_care/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFunction, this.isLoading);

  final bool isLoading;
  final void Function(String email, String password, String gender,
      int age, double weigth, BuildContext ctx) submitFunction;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
//marked as prived and used only in this class
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userPassword = '';
  String _confirmPassword = '';
  String _genderRadioBtnVal = 'Male';
  double _weight;
  // double _height;
  int _age;

  void _onSubmit() {
    final isValid = _formKey.currentState.validate();
    // move the focus away from any input + closes the soft keayboard
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
/*       print(_userEmail);
      print(_userPassword);
      print(_genderRadioBtnVal);
      print(_weight); */
      widget.submitFunction(_userEmail.trim(), _userPassword.trim(), _genderRadioBtnVal, _age, _weight, context);
/*       Navigator.of(context).pushReplacement(MaterialPageRoute(
          //fullscreenDialog: true,
          builder: (context) {
        return HomeScreen();
      })); */
    }
  }

  void _handleGenderChange(String value) {
    setState(() {
      _genderRadioBtnVal = value;
      print(_genderRadioBtnVal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.grey[850],
        margin: EdgeInsets.only(right: 25),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(20),
              child: Text('Signup to get started',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              //color: Colors.grey,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, right: 40),
              child: Text(
                  'In order to provide tailored hydratation advice, we need to get some basic information about you.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  )),
            ),
            SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email address',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber))),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    // password
                    TextFormField(
                      validator: (value) {
                        _confirmPassword = value;
                        if (value.isEmpty || value.length < 7) {
                          return 'password must be at least 7 characters!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber))),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    // confirm password
                    TextFormField(
                      validator: (value) {
                        if (value != _confirmPassword) {
                          return 'The password confirmation does not match.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Confirm password',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber))),
                      obscureText: true,
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: "Male",
                          activeColor: Colors.amber,
                          groupValue: _genderRadioBtnVal,
                          onChanged: _handleGenderChange,
                        ),
                        Text("Male"),
                        Radio(
                          value: "Female",
                          activeColor: Colors.amber,
                          groupValue: _genderRadioBtnVal,
                          onChanged: _handleGenderChange,
                        ),
                        Text("Female"),
                        Radio(
                          value: "Other",
                          activeColor: Colors.amber,
                          groupValue: _genderRadioBtnVal,
                          onChanged: _handleGenderChange,
                        ),
                        Text("Other"),
                      ],
                    ),
                    Row(
                      children: [
                        //age input
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty ||
                                  int.parse(value) > 100 ||
                                  int.parse(value) < 10) {
                                return 'not a valid value';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                            ],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                                labelText: 'Age',
                                labelStyle: TextStyle(color: Colors.white),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.amber))),
                            onSaved: (value) {
                              _age = int.parse(value);
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        // weight input
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty || double.parse(value) < 29) {
                                return 'not a valid value';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^(\d+)?\.?\d{0,2}'))
                            ],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                                labelText: 'Weight(kg)',
                                labelStyle: TextStyle(color: Colors.white),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.amber))),
                            onSaved: (value) {
                              _weight = double.parse(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.amber),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)))),
                            onPressed: _onSubmit,
                            child: Text('sign up',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
