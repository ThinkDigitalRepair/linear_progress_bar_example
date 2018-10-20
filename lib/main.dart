import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/calculations.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double total = 1000.0;
  bool increasing = true;
  StreamController<ProgressCount> _progressController =
      new StreamController<ProgressCount>.broadcast()
        ..stream
            .listen((progressCount) => debugPrint(progressCount.toString()));
  var _inputBoxController = new TextEditingController();
  StreamQueue<ProgressCount> streamQueue;

  var _load = false;

  ProgressCount value;


  @override
  void initState() {
    streamQueue = StreamQueue<ProgressCount>(_progressController.stream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    streamQueue.hasNext.then((hasNext) async {
      if (hasNext) {
        var a = await streamQueue.next;
        setState(() {
          _load = true;
          value = a;
        });
      }
    });
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
        children: <Widget>[
          TextField(
            controller: _inputBoxController,
            decoration: InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.numberWithOptions(),
          ),
          _load
              ? LinearProgressIndicator(
                  value: value.ratio,
                )
              : Container(),
          Text("$value")
        ],
      )),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          generateList(int.parse(_inputBoxController.text))
            ..forEach(_progressController.add);
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


