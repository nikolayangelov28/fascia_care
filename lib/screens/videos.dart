import 'package:flutter/material.dart';

class Videos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Courses'),
      centerTitle: true,
    );

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Text('Courses page'),
      )
    );
  }
}
