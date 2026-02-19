import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Welcome to my app",
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.black,
        ),
      ),
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<StatefulWidget> createState() => _FirstHomePage();
}

class _FirstHomePage extends State<MyHome> {
  var firstNumber = TextEditingController();
  var secondNumber = TextEditingController();
  var result = 0;
  void subtraction() {
    result =
        int.parse(firstNumber.text.toString()) -
        int.parse(secondNumber.text.toString());
    callback();
  }

  void addition() {
    result =
        int.parse(firstNumber.text.toString()) +
        int.parse(secondNumber.text.toString());
    callback();
  }

  void callback() {
    setState(() {});
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My App")),
      body: Column(
        children: [
          TextField(
            controller: firstNumber,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hint: Text("Enter First Number"),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(width: 2, color: Colors.deepOrange),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(width: 1, color: Colors.pink),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(width: 2, color: Colors.pink),
              ),
            ),
          ),

          SizedBox(height: 11),

          TextField(
            controller: secondNumber,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hint: Text("Enter Second Number Number"),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(width: 2, color: Colors.deepOrange),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(width: 1, color: Colors.pink),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(width: 2, color: Colors.pink),
              ),
            ),
          ),

          SizedBox(height: 11),

          Text("Resul = $result"),

          SizedBox(height: 11),

          Row(
            children: [
              ElevatedButton(onPressed: addition, child: Text("+ Addition")),
              SizedBox(width: 11),
              ElevatedButton(
                onPressed: subtraction,
                child: Text("- Subtraction"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
