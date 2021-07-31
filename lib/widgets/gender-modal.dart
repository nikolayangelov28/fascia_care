import 'package:fascia_care/main.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/service/sharedPreferences.dart';
import 'package:flutter/material.dart';

class GenderModal extends StatefulWidget {
  final LocalSharedPreferences sharedPreferences = LocalSharedPreferences();
  final BuildContext context;
  final AppBar appBar;
  GenderModal(this.context, this.appBar);
  @override
  _GenderModalState createState() => _GenderModalState();
}

class _GenderModalState extends State<GenderModal> {
  BuildContext prevContext;
  AppBar prevAppBar;
  final ProfileService profileService = ProfileService();
  String _genderRadioBtnVal;
  String _genderOldValue;
  void _handleGenderChange(StateSetter updateState, String value) {
    updateState(() {
      _genderRadioBtnVal = value;
    });
    setState(() {
      sharedPreferences.setNewGender(value);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _genderOldValue = profileService.gender;
    _genderRadioBtnVal = profileService.gender;
    prevContext = this.widget.context;
    prevAppBar = this.widget.appBar;
  }

/*  */

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        showModalBottomSheet<void>(
            context: context,
            isDismissible: false,
            builder: (BuildContext prevContext) {
              return StatefulBuilder(builder: (prevContext, state) {
                return Container(
                  height: 150,
                  //color: Colors.grey[400],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Select gender'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio(
                                value: 'Male',
                                activeColor: Colors.amber,
                                groupValue: _genderRadioBtnVal,
                                onChanged: (value) {
                                  _handleGenderChange(state, value);
                                }),
                            Text("Male"),
                            Radio(
                                value: "Female",
                                activeColor: Colors.amber,
                                groupValue: _genderRadioBtnVal,
                                onChanged: (value) {
                                  _handleGenderChange(state, value);
                                }),
                            Text("Female"),
                            Radio(
                                value: "Other",
                                activeColor: Colors.amber,
                                groupValue: _genderRadioBtnVal,
                                onChanged: (value) {
                                  _handleGenderChange(state, value);
                                }),
                            Text("Other"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  child: Text('Done'),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(prevContext);
                                      profileService.gender =
                                          _genderRadioBtnVal;
                                    });
                                  }),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(prevContext);
                                      _genderRadioBtnVal =
                                          profileService.gender;
                                          profileService.gender = _genderOldValue;
                                    });
                                  }),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
            })
      },
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      child: Ink(
        height: (MediaQuery.of(context).size.height -
                prevAppBar.preferredSize.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom -
                15) *
            0.08,
        width: (MediaQuery.of(context).size.width - 30) * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Colors.grey[900],
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.person,
                color: Colors.amber,
                size: 30.0,
              ),
            ),
            Text('${profileService.gender}')
          ],
        ),
      ),
    );
  }
}
