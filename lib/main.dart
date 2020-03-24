import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  int currentStepCount;
  int initialStepCount;
  bool countingStarted;
  String btnString;
  Color btnColor;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    currentStepCount = 0;
    initialStepCount = 0;
    countingStarted = false;
    btnString = "Start Counting Steps";
    btnColor = Colors.indigo;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Pedometer App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: screenWidth, height: screenHeight * 0.25),
          Text(
            currentStepCount.toString(),
            style: TextStyle(fontSize: 100, color: Colors.blueGrey),
          ),
          SizedBox(width: screenWidth, height: screenHeight * 0.2),
          RaisedButton(
            color: btnColor,
            child: Text(btnString, style: TextStyle(color: Colors.white, fontSize: 20)),
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onPressed: challengeStartBtn,
          ),
          SizedBox(height: 40),
          FlatButton(
            child: Icon(Icons.refresh, size: 42, color: Colors.blueGrey),
            onPressed: resetAll,
          ),
        ],
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  void startListening() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData, onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void stopListening() {
    _subscription.cancel();
  }

  void _onData(int stepCountValue) async {
    setState(() {
      if (countingStarted) {
        if (initialStepCount == 0) {
          initialStepCount = stepCountValue;
        }
        currentStepCount = (stepCountValue - initialStepCount);
      }
    });
  }

  void challengeStartBtn() {
    setState(() {
      countingStarted = true;
      btnString = "Started Counting Steps";
      btnColor = Colors.indigo.shade100;
    });
  }

  void resetAll() {
    setState(() {
      countingStarted = false;
      initialStepCount = 0;
      currentStepCount = 0;
      btnString = "Start Counting Steps";
      btnColor = Colors.indigo;
    });
  }

  void _onDone() => print("Finished pedometer tracking");
  void _onError(error) => print("Flutter Pedometer Error: $error");
}
