import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'screenRoot.dart';

class Home extends ScreenRoot {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StudyTimer(),
    );
  }
}

class StudyTimer extends StatefulWidget {
  @override
  StudyTimerState createState() => StudyTimerState();
}

class StudyTimerState extends State<StudyTimer> {
  // スクリーン共通カラー
  ScreenColor screenColor = ScreenColor();
  bool _buttonOn = false;

  void _buttonPress() {
    setState(() {
      _buttonOn = !_buttonOn;
    });
    print(_buttonOn);
  }

  String _countTimer = '00:00:00';

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buttonOn ? CountTimer(_countTimer) : Text(_countTimer),
          FloatingActionButton(
            onPressed: _buttonPress,
            backgroundColor: screenColor.subColor,
            child: Text(
              '開始',
              style: TextStyle(
                fontSize: 20,
              )
            ),
          ),
        ],
      ),
    );
  }
}

class CountTimer extends StatefulWidget {
  String countTimer;
  CountTimer(String this.countTimer);
  CountTimerState createState() => CountTimerState(countTimer);
}

class CountTimerState extends State<CountTimer> {
  String countTimer;
  int _seconds = 0;
  int _hour = 0;
  int _minute = 0;
  int _second = 0;
  
  CountTimerState(String this.countTimer);

  @override
  void initState() {
    Timer.periodic(
      Duration(seconds: 1),
      _onTimer
    );
    super.initState();
  }

  void _onTimer(Timer timer) {
    _seconds++;
    _hour = _seconds ~/ (60 * 60);
    _minute = (_seconds - _hour * 60 * 60) ~/ 60;
    _second = _seconds - _hour * 60 * 60 - _minute * 60;
    var time = DateTime(0, 0, 0, _hour, _minute, _second);
    var formatter = DateFormat('HH:mm:ss');
    var formattedTime = formatter.format(time);
    setState(() {
      countTimer = formattedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      countTimer,
      style: TextStyle(
        fontSize: 60,
        color: Colors.black,
      ),
    );
  }
}