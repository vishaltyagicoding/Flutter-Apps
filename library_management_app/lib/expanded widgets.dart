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
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(height: 70, color: Colors.blueAccent),
          ),
          Container(height: 70, color: Colors.amber),
          Container(height: 70, color: Colors.black12),
          Expanded(child: Container(height: 70, color: Colors.red)),
        ],
      ),
    );
  }
}
