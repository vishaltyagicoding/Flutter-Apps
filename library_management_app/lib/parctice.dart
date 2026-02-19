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
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.amber,
            // borderRadius: BorderRadius.circular(33),
            // borderRadius: BorderRadius.only(topLeft: Radius.circular(21)),
            border: Border.all(color: Colors.black, width: 5),
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 11, spreadRadius: 11),
            ],
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
