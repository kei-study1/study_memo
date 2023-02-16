import 'package:flutter/material.dart';

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
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currrentIndex = 0;
  // final List<PageRoot> _pageWidgets = [
  //   const PageRoot(index: 1),
  //   const PageRoot(index: 2),
  //   const PageRoot(index: 3),
  // ];
  final List<PageRoot> _pageWidgets = [
    test1(),
    test2(),
    test3(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: _pageWidgets.elementAt(_currrentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), backgroundColor: Colors.blueAccent, label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_album), backgroundColor: Colors.blueAccent, label: 'Album'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), backgroundColor: Colors.blueAccent, label: 'Chat'),
        ],
        currentIndex:  _currrentIndex,
        fixedColor: Colors.red,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.shifting,
      ),
    );
  }

  void _onItemTapped(int index) => setState(() {
    _currrentIndex = index;
  });
}

// class PageWidget extends StatelessWidget {
//   final Color color;
//   final String title;
//   const PageWidget({super.key, required Color this.color, required String this.title});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: color,
//       child: Center(
//         child: Text(
//           title,
//           style: TextStyle(
//             fontSize: 40,
//           ),
//         ),
//       ),
//     );
//   }
// }

class PageRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class test1 extends PageRoot {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
class test2 extends PageRoot {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
    );
  }
}
class test3 extends PageRoot {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
    );
  }
}







