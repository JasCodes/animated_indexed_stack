import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_indexed_stack/animated_indexed_stack.dart';

main() {
  runApp(
    MaterialApp(
      home: Sw(),
    ),
  );
}

class Sw extends StatefulWidget {
  @override
  _SwState createState() => _SwState();
}

class _SwState extends State<Sw> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedIndexedStack(
        selectedIndex: index,
        children: <Widget>[
          Page(
            title: "Red",
            color: Colors.red,
          ),
          Page(
            title: "Green",
            color: Colors.green,
          ),
          Page(
            title: "Pink",
            color: Colors.pink,
          ),
          Page(
            title: "Grey",
            color: Colors.grey,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            title: Text('Red'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            title: Text('Green'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            title: Text('Megenta'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            title: Text('Grey'),
          ),
        ],
        currentIndex: index,
        onTap: (i) => setState(() {
          index = i;
        }),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String title;
  final Color color;
  const Page({
    Key key,
    this.title,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "Scaffold"),
      ),
      body: Container(
        color: color,
      ),
    );
  }
}
