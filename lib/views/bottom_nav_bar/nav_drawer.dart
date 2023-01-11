import 'package:catevent/utils/app_color.dart';
import 'package:catevent/views/check_out/my_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../about.dart';
import '../community/community.dart';
import '../home/home_screen.dart';
import '../profile/profile.dart';
import 'create_event.dart';
import 'message_screen.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenu(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    DataController dataController = Get.find<DataController>();

    DocumentSnapshot myUser = dataController.allUsers
        .firstWhere((e) => e.id == FirebaseAuth.instance.currentUser!.uid);

    String userImage = '';
    String userName = '';

    try {
      userImage = myUser.get('image');
    } catch (e) {
      userImage = '';
    }

    try {
      userName = '${myUser.get('first')} ${myUser.get('last')}';
    } catch (e) {
      userName = '';
    }
    return Material(
        color: AppColors.maincolor,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileScreen(),
            ));
          },
          child: Container(
            padding: EdgeInsets.only(
              top: 25 + MediaQuery.of(context).padding.top,
              bottom: 25,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                  radius: 50,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildMenu(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Discover Event'),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.event_note_outlined),
          title: const Text('My Activity'),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyActivity(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.grid_view_outlined),
          title: const Text('Create Event'),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateEventView(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.card_giftcard_outlined),
          title: const Text('Rewards'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.volunteer_activism_outlined),
          title: const Text('Community'),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CommunityScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.chat_outlined),
          title: const Text('Chat'),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MessageScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.favorite_border_outlined),
          title: const Text('About cuzVcare'),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const About(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout_outlined),
          title: const Text('Log out'),
          onTap: () {},
        ),
      ],
    );
  }
}