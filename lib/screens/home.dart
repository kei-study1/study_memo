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
  List<ListViewRow> dateTimeStartList = [];
  List<ListViewRow> dateTimeEndList = [];
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
      ListViewRow listViewRow = ListViewRow(DateTime.now(), _buttonOn);
      if (_buttonOn) {
          _timer = Timer.periodic(
          Duration(seconds: 1),
          _onTimer
        );
        dateTimeStartList.add(listViewRow);
      } else {
        _timer.cancel();
        dateTimeEndList.add(listViewRow);
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

  String _makeStringTime(int sec) {
    _hour = sec ~/ (60 * 60);
    _minute = (sec - _hour * 60 * 60) ~/ 60;
    _second = sec - _hour * 60 * 60 - _minute * 60;
    var _time = DateTime(0, 0, 0, _hour, _minute, _second);
    var _formatter = DateFormat('HH:mm:ss');
    return _formatter.format(_time);
  }

  void _onTimer(Timer timer) {
    _seconds++;
    var _formattedTime = _makeStringTime(_seconds);
    setState(() {
      countTimer = _formattedTime;
    });
  }

  String _dateTimeDifference(DateTime start, DateTime end) {
    int diffSeconds = end.difference(start).inSeconds;
    return _makeStringTime(diffSeconds);
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
                height: 150,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    if (dateTimeStartList.length >= index + 1){
                      return Container(
                        decoration: BoxDecoration(
                          // border のカラーに制約がある。null系だと思うから「！」を付けたらOKだった！
                          border: Border(bottom: BorderSide(width: 1.0, color: screenColor.baseColor!))
                        ),
                        child: Row(
                          children: <Widget> [
                            ConRap(DateFormat('HH:mm:ss').format(dateTimeStartList.elementAt(index).getNowDateTime()), 15),
                      
                            (dateTimeEndList.length >= index + 1) ?
                            ConRap(DateFormat('HH:mm:ss').format(dateTimeEndList.elementAt(index).getNowDateTime()), 15) :
                            ConRap('', 15),
                      
                            (dateTimeEndList.length >= index + 1) ?
                            ConRap(
                              _dateTimeDifference(
                                dateTimeStartList.elementAt(index).getNowDateTime(),
                                dateTimeEndList.elementAt(index).getNowDateTime()
                              )
                            , 20) : 
                            ConRap(
                              _dateTimeDifference(
                                dateTimeStartList.elementAt(index).getNowDateTime(),
                                DateTime.now()
                              )
                            , 20),
                            // Text(dateTimeStartList.elementAt(index).getButtonOn() ? "開始" : "終了")
                          ]
                        ),
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

Widget ConRap(String text, double fontSize) {
  return Container(
    width: 100,
    child: Text(
      text,
      // textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize
      ),
    ),
  );
}