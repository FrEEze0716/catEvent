import 'package:flutter/material.dart';

class MyActivityUpcoming extends StatelessWidget {
  MyActivityUpcoming({super.key});

  final titles = ["List 1", "List 2", "List 3"];
  final subtitles = [
    "Here is list 1 subtitle",
    "Here is list 2 subtitle",
    "Here is list 3 subtitle"
  ];
  final icons = [Icons.ac_unit, Icons.access_alarm, Icons.access_time];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Card(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ListTile(
                  // onTap:
                  title: Text(titles[index]),
                  subtitle: Text(subtitles[index]),
                  leading: const CircleAvatar(),
                  trailing: Icon(icons[index])));
        });
  }
}
