import 'package:flutter/material.dart';

import '../../widgets/events_feed_widget.dart';

class MyActivityPast extends StatefulWidget {
  const MyActivityPast({super.key});

  @override
  State<MyActivityPast> createState() => _MyActivityPastState();
}

class _MyActivityPastState extends State<MyActivityPast> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventsIJoined(),
    );
  }
}
