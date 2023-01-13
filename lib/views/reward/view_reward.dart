import 'package:flutter/material.dart';

import '../../widgets/rewards_feed_widget.dart';

class ViewReward extends StatefulWidget {
  const ViewReward({super.key});

  @override
  State<ViewReward> createState() => _ViewRewardState();
}

class _ViewRewardState extends State<ViewReward> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RewardItem(),
    );
  }
}
