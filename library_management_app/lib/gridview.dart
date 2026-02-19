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
  List<Color> colors = [
    Colors.red,
    Colors.redAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.lightBlueAccent,
    Colors.cyan,
    Colors.cyanAccent,
    Colors.teal,
    Colors.tealAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.lime,
    Colors.limeAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.amber,
    Colors.amberAccent,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
    Colors.white,
    Color(0xFF6A1B9A), // Deep Purple 800
    Color(0xFF283593), // Indigo 800
    Color(0xFF1565C0), // Blue 800
    Color(0xFF00838F), // Cyan 800
    Color(0xFF2E7D32), // Green 800
    Color(0xFF558B2F), // Light Green 800
    Color(0xFF9E9D24), // Lime 800
    Color(0xFFF9A825), // Yellow 800
    Color(0xFFEF6C00), // Orange 800
    Color(0xFFD84315), // Deep Orange 800
    Color(0xFF4E342E), // Brown 800
    Color(0xFF37474F), // Blue Grey 800
    Color(0xFF78909C), // Blue Grey 400
    Color(0xFFBDBDBD), // Grey 400
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My App")),
      body: GridView.builder(
        // REQUIRED: gridDelegate
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 10, // Space between columns
          mainAxisSpacing: 10, // Space between rows
          childAspectRatio: 1.0, // Width:Height ratio (1.0 = square)
        ),
        // REQUIRED: itemCount
        itemCount: colors.length,
        // REQUIRED: itemBuilder
        itemBuilder: (context, index) {
          return Container(
            color: colors[index],
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: colors[index].computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
