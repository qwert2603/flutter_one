import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("game"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(42.0),
            child: Text(
              "game ergerger gergergerge gerf ge rg er g erg e gerger",
              style: TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),
          StreamBuilder<int>(
            builder: (context, snapshot) => Text(snapshot.data.toString()),
            stream: intsStream(),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(9, (index) {
                return Container(
                  decoration: BoxDecoration(
                    border: _borders(index),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Border _borders(int index) {
    var borderSide = BorderSide(color: Colors.amber, width: 6);
    switch (index) {
      case 0:
        return Border(right: borderSide, bottom: borderSide);
      case 1:
        return Border(left: borderSide, right: borderSide, bottom: borderSide);
      case 2:
        return Border(left: borderSide, bottom: borderSide);
      case 3:
        return Border(right: borderSide, top: borderSide, bottom: borderSide);
      case 4:
        return Border(
            left: borderSide,
            right: borderSide,
            top: borderSide,
            bottom: borderSide);
      case 5:
        return Border(left: borderSide, top: borderSide, bottom: borderSide);
      case 6:
        return Border(right: borderSide, top: borderSide);
      case 7:
        return Border(left: borderSide, right: borderSide, top: borderSide);
      case 8:
        return Border(left: borderSide, top: borderSide);
      default:
        return Border();
    }
  }
}

Stream<int> intsStream() async* {
  int i = 0;
  while (true) {
    yield i++;

    await Future.delayed(Duration(seconds: 1));
  }
}
