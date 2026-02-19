import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const MyHome());
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});
  @override
  State<StatefulWidget> createState() => _MyHome();
}

class _MyHome extends State<MyHome> {
  double optacity = 1;
  bool togal = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.redAccent, title: Text("Demo")),
      body: Center(
        child: AnimatedOpacity(
          opacity: optacity,
          duration: Duration(seconds: 2),
          curve: Curves.elasticInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 100, height: 100, color: Colors.blue),
              SizedBox(height: 11),
              ElevatedButton(
                onPressed: () {
                  if (togal) {
                    optacity = 0.0;
                    togal = false;
                  } else {
                    optacity = 1;
                    togal = true;
                  }
                  setState(() {});
                },
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.red.shade200,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
