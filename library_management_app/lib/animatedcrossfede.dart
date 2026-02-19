import 'dart:async';

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
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      reload();
    });
  }

  void reload() {
    setState(() {
      isFirst = false;
    });
  }

  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.redAccent, title: Text("Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedCrossFade(
              secondChild: Image.asset(
                "assets/images/icons8-teenager-male-100.png",
              ),
              firstChild: Image.asset("assets/images/icons8-boy-50-2.png"),
              crossFadeState: isFirst
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(seconds: 1),
              firstCurve: Curves.bounceInOut,
              secondCurve: Curves.bounceOut,
            ),
            ElevatedButton(
              onPressed: () {
                if (isFirst) {
                  isFirst = false;
                } else {
                  isFirst = true;
                }
                setState(() {});
              },
              child: Text("Animation"),
            ),
          ],
        ),
      ),
    );
  }
}
