import 'package:flutter/material.dart';

class FirstExpendedWidget extends StatelessWidget {
  const FirstExpendedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue,
        ),

        child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100,
                child: CircleAvatar(backgroundColor: Colors.green),
              ),
            );
          },
          itemCount: 10,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class SecondExpendedWidget extends StatelessWidget {
  const SecondExpendedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: Colors.yellow,
        ),

        child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100,
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.green),
                  title: Text("Name"),
                  subtitle: Text("Mob no"),
                  trailing: Icon(Icons.delete),
                ),
              ),
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }
}

class Third extends StatelessWidget {
  const Third({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: Colors.green,
        ),

        child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Colors.blue,
                ),
              ),
            );
          },
          itemCount: 10,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class Fourth extends StatelessWidget {
  final List<Color> colors = [
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

  Fourth({super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: Colors.purple,
        ),

        child: GridView.builder(
          scrollDirection: Axis.horizontal,
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
      ),
    );
  }
}
