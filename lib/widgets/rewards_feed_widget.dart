import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/data_controller.dart';
import '../utils/app_color.dart';
import '../views/reward/reward.dart';
import 'my_widgets.dart';

// Display all rewards
RewardItem() {
  DataController dataController = Get.find<DataController>();
  DocumentSnapshot? rewardDoc;

  return Column(
    children: [
      Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [
            Obx(
              () => dataController.isRewardsLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: dataController.allRewards.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        String name =
                            dataController.allRewards[i].get('reward_name');

                        String startdate =
                            dataController.allRewards[i].get('start_date');

                        String enddate =
                            dataController.allRewards[i].get('end_date');

                        String point =
                            dataController.allRewards[i].get('point');

                        String rewardImage = '';
                        try {
                          List media =
                              dataController.allRewards[i].get('media') as List;
                          Map mediaItem = media.firstWhere(
                              (element) => element['isImage'] == true) as Map;
                          rewardImage = mediaItem['url'];
                        } catch (e) {
                          rewardImage = '';
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(rewardImage),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '$startdate until $enddate',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 200,
                                          height: 24,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              color: Color(0xffADD8E6),
                                            ),
                                          ),
                                          child: Text(
                                            '$point points required',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                        elevatedButton(
                                          text: 'Redeem',
                                          onpress: () {
                                            FirebaseFirestore.instance
                                                .collection('rewards')
                                                .doc(rewardDoc!.id)
                                                .set({
                                              'redeemed':
                                                  FieldValue.arrayUnion([
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                              ]),
                                              'numRedeem':
                                                  FieldValue.increment(-1),
                                            }, SetOptions(merge: true)).then(
                                              (value) {
                                                FirebaseFirestore.instance
                                                    .collection('redemption')
                                                    .doc(rewardDoc.id)
                                                    .set({
                                                  'redemption':
                                                      FieldValue.arrayUnion([
                                                    {
                                                      'uid': FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      'tickets': 1
                                                    }
                                                  ])
                                                });
                                              },
                                            );
                                            Get.to(() => Reward());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                          ],
                        );
                      },
                    ),
            ),
            Row(
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
          ],
        ),
      ),
    ],
  );
}

ViewRewardRedeemed() {
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

  return Column(
    children: [
      Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                  radius: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Divider(
              color: Color(0xff918F8F).withOpacity(0.2),
            ),
            Obx(
              () => dataController.isRewardsLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: dataController.redempRewards.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        String name =
                            dataController.redempRewards[i].get('reward_name');

                        String point =
                            dataController.redempRewards[i].get('point');

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 65,
                                    height: 24,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Color(0xffADD8E6),
                                      ),
                                    ),
                                    child: Text(
                                      '$point points',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.06,
                                  ),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );
}
