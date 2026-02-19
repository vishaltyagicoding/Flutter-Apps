import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Apps",
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const Home(title: "Hello world"),
    );
  }
}

class Home extends StatefulWidget {
  final String title;
  const Home({super.key, required this.title});
  @override
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State<Home> {
  var values = RangeValues(1, 100);
  @override
  Widget build(BuildContext context) {
    RangeLabels labels = RangeLabels(
      values.start.toString(),
      values.end.toString(),
    );
    return Scaffold(
      appBar: AppBar(title: Text("Welcome to my app")),
      body: RangeSlider(
        values: values,
        labels: labels,
        activeColor: Colors.green,
        inactiveColor: Colors.green.shade100,
        divisions: 10,
        min: 0,
        max: 100,
        onChanged: (newValues) {
          values = newValues;
          print("${values.start}, ${values.end}");
          setState(() {});
        },
      ),
    );
  }
}
