import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IsolPage extends StatefulWidget {
  IsolPage({Key key}) : super(key: key);

  @override
  _IsolPagePageState createState() => _IsolPagePageState();
}

class _IsolPagePageState extends State<IsolPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() => widgets.length == 0;

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.blue),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("page for isolated")),
      body: getBody(),
    );
  }

  getListView() {
    return Scrollbar(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(widgets.length, (position) {
          return getRow(position);
        }),
      ),
    );
  }

  Widget getRow(int i) {
    return ListTile(
      title: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Row ${widgets[i]["title"]}")),
      onTap: () {},
      onLongPress: () {},
    );
  }

  loadData() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // The 'echo' isolate sends its SendPort as the first message
    SendPort sendPort = await receivePort.first;

    List msg = await sendReceive(
        sendPort, "https://jsonplaceholder.typicode.com/posts");

    setState(() {
      widgets = msg;
    });
  }

  // the entry point for the isolate
  static dataLoader(SendPort sendPort) async {
    // Open the ReceivePort for incoming messages.
    ReceivePort port = ReceivePort();

    // Notify any other isolates what port this isolate listens to.
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      SendPort replyTo = msg[1];

      String dataURL = msg[0];
      http.Response response = await http.get(dataURL);

      // Lots of JSON to parse
      replyTo.send(json.decode(response.body));
    }
  }

  Future sendReceive(SendPort port, msg) {
    ReceivePort response = ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }
}
