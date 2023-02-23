import 'package:flutter/material.dart';
import 'package:study_memo/screens/screenRoot.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  // スクリーン共通カラー
  ScreenColor screenColor = ScreenColor();
  // スクリーンのリスト
  ScreenList screenList = ScreenList();
    // テキストフィールド用
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
          backgroundColor: screenColor.baseColor2,
          appBar: AppBar(
            backgroundColor: screenColor.baseColor,
            title: Text('Study_Memo'),
            titleTextStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800
            )
          ),
      
          // body: screenList.screenLists.elementAt(_currentIndex),
          body: IndexedStack(
            index: _currentIndex,
            children: screenList.screenLists,
          ),
      
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: const Icon(Icons.home), backgroundColor: screenColor.baseColor, label: 'Home'),
              BottomNavigationBarItem(icon: const Icon(Icons.photo_album), backgroundColor: screenColor.baseColor, label: 'Album'),
              BottomNavigationBarItem(icon: const Icon(Icons.chat), backgroundColor: screenColor.baseColor, label: 'Chat'),
            ],
            currentIndex: _currentIndex,
            fixedColor: screenColor.subColor,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.shifting,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) => setState(() {
    _currentIndex = index;
  });
}








