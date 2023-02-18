import 'package:flutter/material.dart';
import 'package:study_memo/screens/nameless1.dart';
import 'package:study_memo/screens/nameless2.dart';
import 'home.dart';

class ScreenRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class ScreenList {
  List<ScreenRoot> screenLists = [
    Home(),
    Nameless1(),
    Nameless2(),
  ];
}

class ScreenColor {
  Color? baseColor = Colors.orange[300];
  Color? subColor = Colors.lightBlue[300];
  Color? baseColor2 = Colors.yellow[100];
}
