import 'package:flutter/material.dart';
import 'package:library_management_app/ui_helper/uI_method.dart';

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
        primaryColor: Colors.amber, // Direct primary color
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red, // Explicit AppBar color
          foregroundColor: Colors.black, // Text color
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
      body: Column(
        children: [
          Text(
            "Hello",
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(color: Colors.red),
          ),
          Text("Hey", style: fontsize11()),
          Text("Hey", style: fontsize55()),
        ],
      ),
    );
  }
}
