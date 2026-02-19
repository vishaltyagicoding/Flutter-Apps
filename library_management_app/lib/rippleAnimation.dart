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

class _MyHome extends State<MyHome> with SingleTickerProviderStateMixin {
  List values = [100.0, 150.0, 200.0, 350.0, 450.0];
  // late Animation animation;
  late AnimationController animationController;
  // late Animation colorAnimation;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    animationController.addListener(() {
      setState(() {});
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.redAccent, title: Text("Demo")),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            buildMyRipple(values[0]),
            buildMyRipple(values[1]),
            buildMyRipple(values[2]),
            buildMyRipple(values[3]),
            buildMyRipple(values[4]),
            Icon(Icons.add_call, color: Colors.black, size: 30),
          ],
        ),
      ),
    );
  }

  Widget buildMyRipple(redius) => Container(
    width: redius * animationController.value,
    height: redius * animationController.value,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.blue.withOpacity(1.0 - animationController.value),
    ),
  );
}
