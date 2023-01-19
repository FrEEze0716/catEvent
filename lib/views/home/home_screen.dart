import 'package:catevent/utils/app_color.dart';
import 'package:catevent/views/bottom_nav_bar/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/data_controller.dart';
import '../../services/notification_service.dart';
import '../../widgets/events_feed_widget.dart';
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(32.0),
              ),
              // GPS Function:
              onTap: () async {
                bool servicestatus =
                    await Geolocator.isLocationServiceEnabled();
                if (servicestatus) {
                  print("GPS service is enabled");
                  // https://www.fluttercampus.com/guide/212/get-gps-location/#how-to-check-location-permission-or-request-location-permission
                  LocationPermission permission =
                      await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission == LocationPermission.denied) {
                      print('Location permissions are denied');
                    } else if (permission == LocationPermission.deniedForever) {
                      print("Location permissions are permanently denied");
                    } else {
                      print("GPS Location service is granted");
                    }
                  } else {
                    print("GPS Location permission granted.");
                    Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.best)
                        .timeout(Duration(seconds: 5));

                    try {
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                        position.latitude,
                        position.longitude,
                      );
                      print(placemarks[0]);

                      final CollectionReference locationCollection =
                          FirebaseFirestore.instance.collection('events');
                      final Query location = locationCollection.where("location",
                          isEqualTo: placemarks[0]);

                        // Stream<List<Notice>>get notices{
                        //   return unapproved.snapshots().map(_noticeListFromSnapshot);
                        // }
                    } catch (err) {}
                    // Position position =
                    //     await Geolocator.getCurrentPosition(
                    //         desiredAccuracy: LocationAccuracy.high);
                    // print(position.longitude); //Output: 80.24599079
                    // print(position.latitude); //Output: 29.6593457
                    // String long = position.longitude.toString();
                    // String lat = position.latitude.toString();
                  }
                } else {
                  print("GPS service is disabled.");
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.locationDot),
              ),
            ),
          ),
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
                  "What's Going on Right Now",
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
                            SizedBox(
                              width: 15,
                            ),
                            Text(
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
