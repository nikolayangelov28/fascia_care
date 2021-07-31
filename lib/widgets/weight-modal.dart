import 'package:fascia_care/main.dart';
import 'package:fascia_care/service/profileService.dart';
import 'package:fascia_care/service/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeightModal extends StatefulWidget {
  final LocalSharedPreferences sharedPreferences = LocalSharedPreferences();
  final BuildContext context;
  final AppBar appBar;
  WeightModal(this.context, this.appBar);
  @override
  _WeightModalState createState() => _WeightModalState();
}

class _WeightModalState extends State<WeightModal> {
  final ProfileService profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();
  BuildContext prevContext;
  AppBar prevAppBar;
  double _weight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prevContext = this.widget.context;
    prevAppBar = this.widget.appBar;
  }

  saveWeight() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      profileService.weight = _weight;
      sharedPreferences.setNewWeigth(_weight);
      Navigator.pop(prevContext);
    }
  }

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
                        Text('Select weight'),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Form(
                              key: _formKey,
                              child: Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty || double.parse(value) < 29 || double.parse(value) > 200) {
                                      return 'not a valid value';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                                  ],
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  decoration: InputDecoration(
                                      labelText: 'Weight(kg)',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.amber))),
                                  onSaved: (value) {
                                    _weight = double.parse(value);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
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
                                      saveWeight();
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
          topRight: Radius.circular(0), topLeft: Radius.circular(0)),
      child: Ink(
        height: (MediaQuery.of(context).size.height -
                prevAppBar.preferredSize.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom -
                15) *
            0.08,
        width: (MediaQuery.of(context).size.width - 30) * 1,
        decoration: BoxDecoration(
          color: Colors.grey[900],
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.accessibility,
                color: Colors.amber,
                size: 30.0,
              ),
            ),
            Text('${profileService.weight}')
          ],
        ),
      ),
    );
  }
}
