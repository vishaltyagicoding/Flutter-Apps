import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globlestate/lismapprovider.dart';
import 'package:provider/provider.dart';

class Buttonpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("data button")),
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            Map<String, dynamic> data = {
              "name": "Vishal",
              "address": "94 Neerja nagar Bhopal",
            };
            context.read<ListMapProvider>().addData(data);
          },
          tooltip: 'Add Item',
          child: const Icon(Icons.add), // Changed back to 'add' for adding data
        ),
      ),
    );
  }
}
