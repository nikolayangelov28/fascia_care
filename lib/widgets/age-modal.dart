import 'package:fascia_care/service/profileService.dart';
import 'package:flutter/material.dart';

class AgeModal extends StatefulWidget {
  final BuildContext context;
  final AppBar appBar;
  AgeModal(this.context, this.appBar);
  @override
  _AgeModalState createState() => _AgeModalState();
}

class _AgeModalState extends State<AgeModal> {
  final ProfileService profileService = ProfileService();
  BuildContext prevContext;
  AppBar prevAppBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prevContext = this.widget.context;
    prevAppBar = this.widget.appBar;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
              bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
          color: Colors.grey[900],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Icon(
                Icons.cake,
                color: Colors.white38,
                size: 30.0,
              ),
            ),
            Text('${profileService.age}')
          ],
        ),
      ),
    );
  }
}
