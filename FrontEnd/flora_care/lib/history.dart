import 'package:flutter/material.dart';

import 'HiveBoxes.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Image.asset(
              'assets/logo-rm.png',
              fit: BoxFit.fitHeight,
              height: 40,
            ),
            Text("Flora care")
          ]),
          backgroundColor: Colors.lightGreenAccent,
        ),
        body: ListView.builder(
          itemCount: HiveBoxes.history.items.length,
          itemBuilder: (context, index) {
            final item = HiveBoxes.history.items[index];
            final diseaseName = item[0]; // Access disease name from the list

            return ListTile(
              title: Text(diseaseName),
              // You can display other data (solution, image) as needed
            );
          },
        ));
  }
}
