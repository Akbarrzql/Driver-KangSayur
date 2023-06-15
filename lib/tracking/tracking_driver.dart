import 'package:flutter/material.dart';

class TrackingDriver extends StatefulWidget {
  const TrackingDriver({Key? key}) : super(key: key);

  @override
  State<TrackingDriver> createState() => _TrackingDriverState();
}

class _TrackingDriverState extends State<TrackingDriver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Tracking Driver"),
      ),
    );
  }
}
