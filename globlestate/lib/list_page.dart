import 'package:flutter/material.dart';
import 'package:globlestate/buttonpage.dart';
import 'package:globlestate/lismapprovider.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List page")),
      body: Consumer<ListMapProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.data.length,
            itemBuilder: (context, index) {
              final item = provider.data[index];
              return ListTile(
                title: Text(item['name'] ?? 'No Name'),
                subtitle: Text(item['address'] ?? 'No Address'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Buttonpage()),
          );
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add), // Changed back to 'add' for adding data
      ),
    );
  }
}
