import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CounterWithFile extends StatefulWidget {
  const CounterWithFile({super.key});

  @override
  State<CounterWithFile> createState() => _CounterWithFile();
}

class _CounterWithFile extends State<CounterWithFile> {
  var app;
  var counterValue = 0;

  @override
  void initState() {
    super.initState();

    getApplicationDocumentsDirectory().then(
      (value) {
        app = value;

        readData('counter.txt');
      },
    );
  }

  void saveData(String filename) {
    File file = File('${app.path}/$filename');
    file.writeAsStringSync(counterValue.toString());
  }

  void readData(String filename) {
    File file = File('${app.path}/$filename');

    if (file.existsSync()) {
      setState(() {
        counterValue = int.parse(file.readAsStringSync());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Column(
            spacing: 25,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                counterValue.toString(),
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: incrementCounter,
                    child: Icon(Icons.add),
                  ),
                  ElevatedButton(
                    onPressed: decrementCounter,
                    child: Icon(Icons.remove),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void incrementCounter() {
    setState(() {
      counterValue++;
      saveData('counter.txt');
    });
  }

  void decrementCounter() {
    if (counterValue > 0) {
      setState(() {
        counterValue--;
        saveData('counter.txt');
      });
    }
  }
}
