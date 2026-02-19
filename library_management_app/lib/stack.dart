import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.black,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 55,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
          headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My App")),
      body: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          children: [
            Container(width: 200, height: 200, color: Colors.yellow),
            Positioned(
              left: 21,
              top: 21,
              child: Container(width: 200, height: 200, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
