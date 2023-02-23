import 'dart:ffi';

import 'package:flutter/foundation.dart';
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
  String currentListTimer = '00:00:00';
  int diffSeconds = 0;
  List<DateTime> dateTimeBetweenList = [];
  int _hour = 0;
  int _minute = 0;
  int _second = 0;
  // スクロールコントローラー
  ScrollController _scrollController = ScrollController();
  int _itemCount = 1;

  // タイマースタート＆ストップ
  void _buttonPress() {
    setState(() {
      _buttonOn = !_buttonOn;
      ListViewRow listViewRow = ListViewRow(DateTime.now(), _buttonOn);
      if (_buttonOn) {
        _timer = Timer.periodic(
          Duration(microseconds: 1000),
          _onTimer
        );
        dateTimeStartList.add(listViewRow);
        _itemCount++;
      } else {
        _timer.cancel();
        dateTimeEndList.add(listViewRow);
      }
    });
    print(_buttonOn);
  }

  // Timerのメソッドを使うカウント用。正直Timer.periodicを使いたいだけの生贄メソッド
  void _onTimer(Timer timer) {
    setState(() {
      dateTimeBetweenList.insert(dateTimeStartList.length - 1,
        _dateTimeDiff(
          dateTimeStartList.elementAt(dateTimeStartList.length - 1)._nowDateTime,
          DateTime.now()
        )
      );
      countTimer = _makeStringTime(_totalSeconds());
    });
  }

  // タイマーリストの時間を合算して秒数で渡す
  int _totalSeconds() {
    int _totalSeconds = 0;
    for (int i = 0; i < dateTimeStartList.length; i++) {
      _totalSeconds += _makeSeconds(dateTimeBetweenList.elementAt(i));
    }
    return _totalSeconds;
  }

  // DateTime型をintの秒に変換して渡す
  int _makeSeconds(DateTime t) {
    int _tHourSec = t.hour * 60 * 60;
    int _tMinuteSec = t.minute * 60;
    return _tHourSec + _tMinuteSec + t.second;
  }

  // 開始時刻と終了時刻の差をStringの 00:00:00 にして渡す
  String _dateTimeDifference(DateTime start, DateTime end) {
    diffSeconds = end.difference(start).inSeconds;
    return _makeStringTime(diffSeconds);
  }
  // 2つのDateTimeの差をDateTimeで返す
  DateTime _dateTimeDiff(DateTime s, DateTime e) {
    var s1 = _makeSeconds(e) - _makeSeconds(s);
    var h = s1 ~/ (60 * 60);
    var m = (s1 - h * 60 *60) ~/ 60;
    var s2 = s1 - h * 60 * 60 - m * 60;
    return DateTime(0,0,0,h,m,s2);
  }

  // 送られた秒数をStringの 00:00:00 で表示
  String _makeStringTime(int sec) {
    _hour = sec ~/ (60 * 60);
    _minute = (sec - _hour * 60 * 60) ~/ 60;
    _second = sec - _hour * 60 * 60 - _minute * 60;
    var _time = DateTime(0, 0, 0, _hour, _minute, _second);
    var _formatter = DateFormat('HH:mm:ss');
    return _formatter.format(_time);
  }

  // indexのタイマーリストを削除する
  void _deleteList(int index) {
    setState(() {
      dateTimeStartList.removeAt(index);
      dateTimeBetweenList.removeAt(index);
      if (dateTimeEndList.length >= index + 1) {
        dateTimeEndList.removeAt(index); 
      } else {
        _buttonOn = !_buttonOn;
        _timer.cancel();
      }
      countTimer = _makeStringTime(_totalSeconds());
      _itemCount--;
    });
  }

  // リストを最下までスクロール
  void _arrowPress() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.linear
    );
  }

  Widget build(BuildContext context) {
    return Container(
      height:  MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 10,),
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
            
                SizedBox(height: 10,),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      color: _buttonOn? screenColor.baseColor : Color.fromARGB(255, 167, 157, 133),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: 242,
                        child: Text(
                          countTimer,
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            
                    const SizedBox(width: 10,),
            
                    FloatingActionButton(
                      onPressed: _buttonPress,
                      splashColor: _buttonOn ? screenColor.baseColor : screenColor.subColor,
                      backgroundColor: _buttonOn ? screenColor.subColor : screenColor.baseColor,
                      child: Icon(_buttonOn ? Icons.stop_circle_outlined : Icons.play_circle_outline, size: 40,),
                    ),
            
                  ],
                ),
                
                const SizedBox(height: 10,),
            
                Container(
                  width: 350,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget> [
                            ConRap('開始', 15),
                            ConRap('終了', 15),
                            ConRap('経過時間', 15),
                            Container(
                              width: 40,
                              child: FloatingActionButton(
                                foregroundColor: Colors.white,
                                backgroundColor: screenColor.subColor,
                                splashColor: Colors.white,
                                child: Icon(Icons.keyboard_double_arrow_down_rounded, size: 35,),
                                onPressed: _arrowPress,
                              ),
                            ),
                          ]
                        ),
                      ),
                      Container(
                        height: 160,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _itemCount,
                          itemBuilder: (BuildContext context, int index) {
                            if (dateTimeStartList.length >= index + 1){
                              return Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  // border のカラーに制約がある。null系だと思うから「！」を付けたらOKだった！
                                  border: Border(bottom: BorderSide(width: 1.0, color: screenColor.baseColor!))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget> [
                                    ConRap(DateFormat('HH:mm:ss').format(dateTimeStartList.elementAt(index).getNowDateTime()), 15),
                              
                                    (dateTimeEndList.length >= index + 1) ?
                                      ConRap(DateFormat('HH:mm:ss').format(dateTimeEndList.elementAt(index).getNowDateTime()), 15) :
                                      ConRap('', 15),
                      
                                    (dateTimeBetweenList.length >= index + 1) ?
                                      ConRap(
                                        DateFormat('HH:mm:ss').format(
                                          dateTimeBetweenList.elementAt(index)
                                        )
                                      , 20) :
                                      ConRap('', 20),
                      
                                    InkWell(
                                      onTap: null,
                                      onLongPress: () => _deleteList(index),
                                      child: Container(
                                        width: 40,
                                        child: FloatingActionButton(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.redAccent.shade200,
                                          splashColor: Colors.white,
                                          child: Icon(Icons.delete_forever, size: 30,),
                                          onPressed: (){},
                                        ),
                                      ),
                                    ),
                                  ]
                                ),
                              );
                            }
                          }
                        ),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 30,),
            
                Container(
                  color: Colors.white,
                  width: 300,
                  child: const TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "memo",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
        
            const SizedBox(height: 20,),
            
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
    width: 95,
    // color : Colors.red,
    child: Text(
      text,
      // textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize
      ),
    ),
  );
}