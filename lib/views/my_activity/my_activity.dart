import 'package:catevent/views/my_activity/my_activity_past.dart';
import 'package:catevent/views/my_activity/my_activity_upcoming.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class MyActivity extends StatelessWidget {
  const MyActivity({super.key});

  TabBar get _tabBar => const TabBar(
        indicatorWeight: 5,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Color.fromRGBO(252, 192, 211, 1),
        labelColor: Color.fromRGBO(252, 192, 211, 1),
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(text: 'Upcoming'),
          Tab(text: 'Past'),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // drawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text('My Activity'),
          backgroundColor: AppColors.maincolor,
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.white,
              child: _tabBar,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            MyActivityUpcoming(),
            MyActivityPast(),
          ],
        ),
      ),
    );
  }
}
