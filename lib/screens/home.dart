import 'dart:ffi';

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
  // 日付
  final DateTime _now = DateTime.now();
  late final int _nowYear = _now.year;
  late final int _nowMonth = _now.month;
  late final int _nowDay = _now.day;
  late final int _nowWeek = _now.weekday;
  late final String _nowWeekWord = _weekday.elementAt(_nowWeek - 1);
  final List<String> _weekday = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
  List<ListViewRow> dateTimeList = [];
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
    ListViewRow listViewRow = ListViewRow(DateTime.now(), _buttonOn);
    dateTimeList.add(listViewRow);
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("$_nowYear",
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Text("$_nowMonth" ".",
                    style: const TextStyle(
                      fontSize: 30
                    ),
                  ),
                  Text("$_nowDay",
                    style: const TextStyle(
                      fontSize: 30
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Text(_nowWeekWord,
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Card(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              width: 284,
                              child: Text(
                                countTimer,
                                style: TextStyle(
                                  fontSize: 60,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: null,
                                onLongPress: _resetButtonPress,
                                child: FloatingActionButton(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  splashColor: Colors.white,
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
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
              
              const SizedBox(height: 10,),

              Container(
                // color: Colors.red,
                height: 150,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    if (dateTimeList.length >= index + 1){
                      return Row(
                        children: <Widget> [
                          Text(DateFormat('HH時mm分ss秒').format(dateTimeList.elementAt(index).getNowDateTime())),
                          const SizedBox(width: 5,),
                          Text(dateTimeList.elementAt(index).getButtonOn() ? "開始" : "終了")
                        ]
                      );
                    }
                  }
                ),
              ),

              const SizedBox(height: 10,),

              Container(
                color: Colors.white,
                width: 300,
                child: const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  // enabled: true,
                  // maxLength: 10,
                ),
              ),
            ],
          ),

          Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 100, right: 100),
                  backgroundColor: screenColor.baseColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                ),
                child: Text(
                  '登録する',
                  style: TextStyle(
                    fontSize: 20
                  ),
                )
              ),
              const SizedBox(height: 10,)
            ],
          ),
        ],
      ),
    );
  }
}

class ListViewRow {
  late DateTime _nowDateTime;
  late bool _buttonOn;

  ListViewRow(this._nowDateTime, this._buttonOn);

  DateTime getNowDateTime() {
    return _nowDateTime;
  }
  bool getButtonOn() {
    return _buttonOn;
  }
}