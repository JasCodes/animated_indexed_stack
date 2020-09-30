import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_indexed_stack/animated_indexed_stack.dart';

main() {
  runApp(
    MaterialApp(
      home: SimpleTabSelector(),
    ),
  );
}

class SimpleTabSelector extends StatefulWidget {
  @override
  _SimpleTabSelectorState createState() => _SimpleTabSelectorState();
}

class _SimpleTabSelectorState extends State<SimpleTabSelector> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey[100],
        child: AnimatedIndexedStack(
          selectedIndex: index,
          children: <Widget>[
            ColoredPage(
              title: "Red",
              color: Colors.red,
            ),
            ColoredPage(
              title: "Green",
              color: Colors.green,
            ),
            ColoredPage(
              title: "Pink",
              color: Colors.pink,
            ),
            ColoredPage(
              title: "Grey",
              color: Colors.grey,
            ),
          ],
        ),
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

class ColoredPage extends StatelessWidget {
  final String title;
  final Color color;
  const ColoredPage({
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
