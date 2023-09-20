import 'dart:developer';

import 'package:book_a_bite_user/modules/cart/logic.dart';
import 'package:book_a_bite_user/modules/cart/state.dart';
import 'package:book_a_bite_user/modules/notifactions/logic.dart';
import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final CartLogic logic = Get.put(CartLogic());
  final CartState state = Get.find<CartLogic>().state;

  final NotificationLogic logicNotification = Get.put(NotificationLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationLogic>(builder: (data) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.clear_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notifications",
                  style: state.appBarTextStyle,
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Text(
                      "Get Bite Alert notifications when you favourite a BiteHub or select a distance range near you",
                      style: GoogleFonts.nunito(
                        color: customTextGreyColor.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                  height: Get.height * 0.05,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "By closest location in KM",
                      style: GoogleFonts.nunito(
                        color: customTextGreyColor.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    FlutterSwitch(
                      width: 50.0,
                      height: 25.0,
                      valueFontSize: 15.0,
                      toggleSize: 25.0,
                      // value: status,
                      activeColor: customThemeColor,
                      borderRadius: 30.0,
                      padding: 0.0,
                      showOnOff: false,
                      onToggle: (val) {
                        log(val.toString());
                        data.locationSubscribed = val;
                        data.update();
                      },
                      value: data.locationSubscribed,
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                // FlutterSlider(
                //   values: [data.lowerValue, data.upperValue],
                //   max: 5,
                //   min: 0,
                //   onDragging: (handlerIndex, lowerValue, upperValue) {
                //     data.lowerValue = lowerValue;
                //     data.upperValue = upperValue;
                //     data.update();
                //   },
                // ),
                SfRangeSlider(
                  activeColor: customThemeColor,
                  inactiveColor: Colors.grey.withOpacity(0.5),
                  min: 0.0,
                  max: 5.0,
                  values: SfRangeValues(data.lowerValue, data.upperValue),
                  interval: 1,
                  showTicks: true,
                  showLabels: true,
                  minorTicksPerInterval: 1,
                  onChanged: (SfRangeValues values) {
                    setState(() {
                      data.lowerValue = values.start;
                      data.upperValue = values.end;
                      data.update();
                    });
                  },
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: Text(
                //     data.lowerValue.toString() + "KM",
                //     style: const GoogleFonts.nunito(
                //         color: Colors.grey,
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500),
                //   ),
                // ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "By favourites",
                      style: GoogleFonts.nunito(
                        color: customTextGreyColor.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    FlutterSwitch(
                      width: 50.0,
                      height: 25.0,
                      valueFontSize: 15.0,
                      toggleSize: 25.0,
                      // value: status,
                      activeColor: customThemeColor,
                      borderRadius: 30.0,
                      padding: 0.0,
                      showOnOff: false,
                      onToggle: (val) {
                        data.favouriteSubscribed = val;
                        data.update();
                      },
                      value: data.favouriteSubscribed,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        data.saveNotificationSettings();
                      },
                      child: Container(
                        height: Get.height * 0.07,
                        width: Get.width,
                        decoration: BoxDecoration(
                            color: customThemeColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            "Save Notification",
                            style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      );
    });
  }
}
