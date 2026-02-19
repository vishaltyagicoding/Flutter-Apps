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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.redAccent, title: Text("Demo")),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Flip()),
            );
          },
          child: Hero(
            tag: "background",
            child: ClipRRect(
              // borderRadius: BorderRadius.all(Radius.elliptical(200, 151)),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                topLeft: Radius.circular(201),
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(201),
              ),
              child: Image.asset(
                "assets/images/screenshot.png",
                width: 300,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Flip extends StatelessWidget {
  const Flip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: "background",
        child: Image.asset("assets/images/screenshot.png"),
      ),
    );
  }
}
