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
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _width = 200;
  double _height = 100;
  bool flag = true;
  Decoration mydec = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.amber,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 1),
              width: _width,
              height: _height,
              decoration: mydec,
              curve: Curves.fastOutSlowIn,
            ),
            SizedBox(height: 11),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (flag) {
                    mydec = BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                    );
                    _width = 100;
                    _height = 200;
                    flag = false;
                  } else {
                    mydec = BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber,
                    );
                    _width = 200;
                    _height = 100;
                    flag = true;
                  }
                });
              },
              child: Text("Animation"),
            ),
          ],
        ),
      ),
    );
  }
}
