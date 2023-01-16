import 'package:catevent/widgets/rewards_feed_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class AdminViewReward extends StatefulWidget {
  const AdminViewReward({super.key});

  @override
  State<AdminViewReward> createState() => _AdminViewRewardState();
}

class _AdminViewRewardState extends State<AdminViewReward> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reward'),
        backgroundColor: AppColors.maincolor,
      ),
      body: RewardsFeed(),
    );
  }
}
