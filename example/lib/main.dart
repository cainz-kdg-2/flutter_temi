import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_temi/flutter_temi.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool IsBusyMode = false;
  StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    FlutterTemi.temiSubscribeToOnLocationStatusChangeEvents().listen((event) {
      print('Location event: ${event}');
      print('Location event status : ${event['status']}');
      if (event['status'] == "complete") {
        FlutterTemi.temiSpeak("I have arrive from whatever ");
      }
      print('Location event: ${event.runtimeType}');
    });

    SubTemi();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Temi Plugin example app'),
        ),
        body: Center(
          child: Wrap(
            children: <Widget>[


              FlatButton(
                child: Text('Goto Allen'),
                onPressed: () async {
                  await FlutterTemi.temiGoTo('allen');
                  await FlutterTemi.temiSpeak('Allen I am coming');
                },
              ),
              FlatButton(
                child: Text('Goto Victor'),
                onPressed: () async => FlutterTemi.temiGoTo('victor'),
              ),
              FlatButton(
                child: Text('Speak Victor'),
                onPressed: () async => FlutterTemi.temiSpeak('victor is Great'),
              ),
              FlatButton(
                child: Text('Save Location -- Allen'),
                onPressed: () async => FlutterTemi.temiSaveLocation('Allen'),
              ),
              FlatButton(
                child: Text('Follow me'),
                onPressed: () async => FlutterTemi.temiFollowMe(),
              ),
              FlatButton(
                child: Text('Skid Joy'),
                onPressed: () async => FlutterTemi.temiSkidJoy(2.0, 2.0),
              ),
              FlatButton(
                child: Text('Title Angle'),
                onPressed: () async {
                  var degree = -20;
                  await FlutterTemi.temiTiltAngle(degree);
                  print(" 1- Tilt by ${degree}");

                  await Future.delayed(Duration(milliseconds: 1000));

                  var degreeTwo = -20;
                  await FlutterTemi.temiTiltAngle(degreeTwo);
                  print("2- Tilt by ${degreeTwo}");

                  await Future.delayed(Duration(milliseconds: 1000));

                  var degreethree = 30;
                  await FlutterTemi.temiTiltAngle(degreethree);
                  print("3-  Tilt by ${degreethree}");

                  SubTemi();
                },
              ),
              FlatButton(
                child: Text('Trun by'),
                onPressed: () async {
                  await FlutterTemi.temiTurnBy(90);
                  await Future.delayed(Duration(seconds: 3));
                  await FlutterTemi.temiTurnBy(-180);
                },
              ),
              FlatButton(
                child: Text('Title  by'),
                onPressed: () async => FlutterTemi.temiTiltBy(15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void SubTemi() {
    sub = FlutterTemi.temiSubscribeToDetectionStateChangedEvents()
        .listen((event) {
      if (event == 2) {
        print("user Deteched ${event}");
        IsBusyMode == true;
        sub.cancel();
      }
    });
  }
}
