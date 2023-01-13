import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/data_controller.dart';
import '../utils/app_color.dart';

// Display all rewards
RewardItem() {
  DataController dataController = Get.find<DataController>();

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

                        startdate = startdate.split('-')[0] +
                            '-' +
                            startdate.split('-')[1];

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
                                        Container(
                                          width: 41,
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
                                            startdate,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black,
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
