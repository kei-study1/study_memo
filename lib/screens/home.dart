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
  // タイマー関係
  late Timer _timer;
  String countTimer = '00:00:00';
  int _seconds = 0;
  int _hour = 0;
  int _minute = 0;
  int _second = 0;

  void _buttonPress() {
    setState(() {
      _buttonOn = !_buttonOn;
      if (_buttonOn) {
          _timer = Timer.periodic(
          Duration(seconds: 1),
          _onTimer
        );
      } else {
        _timer.cancel();
      }
    });
    print(_buttonOn);
  }
  void _resetButtonPress() {
    setState(() {
      countTimer = '00:00:00';
      _seconds = 0;
      _buttonOn = false;
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
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

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 300,
            color: Colors.red,
            child: Text(
              countTimer,
              style: TextStyle(
                fontSize: 60,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: null,
                onLongPress: _resetButtonPress,
                child: FloatingActionButton(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Colors.red,
                      width: 3
                    )
                  ),
                  splashColor: Colors.red,
                  child: Icon(Icons.restart_alt_outlined, size: 40,),
                  onPressed: (){},
                ),
              ),
              FloatingActionButton(
                onPressed: _buttonPress,
                splashColor: _buttonOn ? screenColor.baseColor : screenColor.subColor,
                backgroundColor: _buttonOn ? screenColor.subColor : screenColor.baseColor,
                child: Icon(_buttonOn ? Icons.stop_circle_outlined : Icons.play_circle_outline, size: 40,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}