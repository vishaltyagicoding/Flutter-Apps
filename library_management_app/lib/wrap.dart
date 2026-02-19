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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome to my app")),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Wrap(
          // direction: Axis.vertical,
          alignment: WrapAlignment.spaceAround,
          spacing: 11,
          runSpacing: 11,
          children: [
            Container(width: 100, height: 100, color: Colors.purple),
            Container(width: 100, height: 100, color: Colors.deepOrange),
            Container(width: 100, height: 100, color: Colors.green),
            Container(width: 100, height: 100, color: Colors.lightGreen),
            Container(width: 100, height: 100, color: Colors.amber),
            Container(width: 100, height: 100, color: Colors.red),
            Container(width: 100, height: 100, color: Colors.orange),
            Container(width: 100, height: 100, color: Colors.pink),
            Container(width: 100, height: 100, color: Colors.blueAccent),
            Container(width: 100, height: 100, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
