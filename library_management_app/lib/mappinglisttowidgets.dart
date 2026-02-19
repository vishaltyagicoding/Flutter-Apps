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
  List<Map<String, dynamic>> users = [
    {'id': 1, 'name': 'Alice', 'email': 'alice@example.com'},
    {'id': 2, 'name': 'Bob', 'email': 'bob@example.com'},
    {'id': 3, 'name': 'Charlie', 'email': 'charlie@example.com'},
    {'id': 4, 'name': 'Diana', 'email': 'diana@example.com'},
    {'id': 5, 'name': 'Eve', 'email': 'eve@example.com'},
    {'id': 6, 'name': 'Frank', 'email': 'frank@example.com'},
    {'id': 7, 'name': 'Grace', 'email': 'grace@example.com'},
    {'id': 8, 'name': 'Henry', 'email': 'henry@example.com'},
    {'id': 9, 'name': 'Ivy', 'email': 'ivy@example.com'},
    {'id': 10, 'name': 'Jack', 'email': 'jack@example.com'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: ListView(
        children: users.map((value) {
          return ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(value["name"].toString()),
            subtitle: Text(value["email".toString()]),
            trailing: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green.shade300,
              child: Text(value["id"].toString()),
            ),
          );
        }).toList(),
      ),
    );
  }
}
