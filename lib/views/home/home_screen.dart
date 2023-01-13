import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/data_controller.dart';
import '../../services/notification_service.dart';
import '../../utils/app_color.dart';
import '../../widgets/events_feed_widget.dart';
import '../nav_bar/nav_drawer.dart';
import '../notification_screen/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(DataController(), permanent: true);
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });

    LocalNotificationService.storeToken();
  }

  @override
  Widget build(BuildContext context) {
    DataController dataController = Get.find<DataController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('cuzVcare - Home'),
        backgroundColor: AppColors.maincolor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              Get.to(() => UserNotificationScreen());
            },
          ),
        ],
      ),
      drawer: const NavDrawer(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Text(
                  "What Going on today",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                EventsFeed(),
                Obx(
                  () => dataController.isUsersLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              child: Image.asset(
                                'assets/doneCircle.png',
                                fit: BoxFit.cover,
                                color: AppColors.blue,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Text(
                              'You\'re all caught up!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
