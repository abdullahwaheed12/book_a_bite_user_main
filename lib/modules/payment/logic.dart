import 'dart:developer';
import 'dart:math' as math;

import 'package:book_a_bite_user/controller/fcm_controller.dart';
import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:book_a_bite_user/modules/cart/logic.dart';
import 'package:book_a_bite_user/modules/home/logic.dart';
import 'package:book_a_bite_user/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class PaymentLogic extends GetxController {
  final state = PaymentState();

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpiryController = TextEditingController();
  TextEditingController cardCVCController = TextEditingController();

  int? cardRadioGroupValue = 1;
  int? bankRadioGroupValue = 2;
  int? radioValue = 0;
  updateRadioValue(int? newValue) {
    radioValue = newValue;
    update();
  }

  String? paymentToken;

  //!--------- for chairty
  String? paymentTokenForChairty;

  ///---random-string-open
  String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String charsForOtp = '1234567890';
  math.Random rnd = math.Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  String getRandomOtp(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => charsForOtp.codeUnitAt(rnd.nextInt(charsForOtp.length))));
  int? bitePoints;

  /// order in the firebase
  placeOrder() async {
    try {
      String? getOtp = getRandomOtp(5);

      bitePoints = Get.find<CartLogic>().radioValue!
          ? Get.find<CartLogic>().grandTotal!.toInt() + 2
          : Get.find<CartLogic>().grandTotal!.toInt();
      bitePoints = Get.find<CartLogic>().isBringYourOwnBag!
          ? Get.find<CartLogic>().grandTotal!.toInt() + 2
          : Get.find<CartLogic>().grandTotal!.toInt();
      update();
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('cart')
          .where("uid",
              isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
          .get();
      QuerySnapshot queryForRestImage = await FirebaseFirestore.instance
          .collection('restaurants')
          .where("id", isEqualTo: query.docs[0].get('restaurant_id'))
          .get();

      if (query.docs.isNotEmpty) {
        FirebaseFirestore.instance.collection('orders').doc().set({
          'restaurant': query.docs[0].get('restaurant'),
          'restaurant_id': query.docs[0].get('restaurant_id'),
          'go_green': Get.find<CartLogic>().radioValue!,
          'BOYB': Get.find<CartLogic>().isBringYourOwnBag,
          'restaurant_image': queryForRestImage.docs[0].get('image'),
          'total_price': Get.find<CartLogic>().totalPrice!.toPrecision(2),
          'total_discount': Get.find<CartLogic>().totalDiscount!.toPrecision(2),
          'coupon_discount': Get.find<CartLogic>().couponDiscount,
          'total_discount_percentage':
              ((double.parse(Get.find<CartLogic>().totalDiscount.toString()) /
                          double.parse(
                              Get.find<CartLogic>().totalPrice.toString())) *
                      100)
                  .toPrecision(2),
          'charity': Get.find<CartLogic>().hideCharity! ? 0 : 1,
          'net_price': Get.find<CartLogic>().netPrice!.toPrecision(2),
          'grand_total': Get.find<CartLogic>().grandTotal!.toPrecision(2),
          'product_list': List.generate(query.docs.length, (index) {
            return {
              'quantity': query.docs[index].get('quantity'),
              'original_price': query.docs[index].get('original_price'),
              'dis_price': query.docs[index].get('dis_price'),
              'discount': query.docs[index].get('discount'),
              'name': query.docs[index].get('name') == ''
                  ? 'Bite Bag'
                  : query.docs[index].get('name'),
              'chef_note': query.docs[index].get('chef_note'),
              'category': query.docs[index].get('category'),
              'image': query.docs[index].get('image'),
              'product_id': query.docs[index].get('product_id'),
            };
          }),
          'customerName': Get.find<HomeLogic>().currentUserData!.get('name'),
          'uid': Get.find<HomeLogic>().currentUserData!.get('uid'),
          'date_time': DateTime.now(),
          'status': 'Pending',
          'bite_points': bitePoints,
          'review_status': 'pending',
          'otp': getOtp,
          'id': getRandomString(5),
        });
        // Get.find<GeneralController>().updateFormLoader(false);

        QuerySnapshot queryForFcm = await FirebaseFirestore.instance
            .collection('users')
            .where("uid", isEqualTo: queryForRestImage.docs[0].get('uid_id'))
            .get();
        sendNotificationCall(
            queryForFcm.docs[0].get('token'),
            'Order received ${query.docs[0].get('name') == '' ? 'Bite Bag' : query.docs[0].get('name')} ',
            '');

        QuerySnapshot queryForFcmPersonal = await FirebaseFirestore.instance
            .collection('users')
            .where("uid",
                isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
            .get();
        sendNotificationCall(
            queryForFcmPersonal.docs[0].get('token'),
            'Sweet as! Your Bite Hub order has been successfully placed with ${query.docs[0].get('restaurant')}',
            '');

        ///---quantity-set
        // for (var element in query.docs) async {
        //   QuerySnapshot quantityQuery = await FirebaseFirestore.instance
        //       .collection(element.get('name') == '' ? 'biteBags' : 'products')
        //       .where("id", isEqualTo: element.get('product_id'))
        //       .get();
        //   if (quantityQuery.docs.isNotEmpty) {
        //     FirebaseFirestore.instance
        //         .collection(element.get('name') == '' ? 'biteBags' : 'products')
        //         .doc(quantityQuery.docs[0].id)
        //         .update({
        //       'quantity': FieldValue.increment(
        //           -int.parse((element.get('quantity')).toString())),
        //     });
        //   }
        // }

        ///---delete-cart
        QuerySnapshot deleteQuery = await FirebaseFirestore.instance
            .collection('cart')
            .where("uid",
                isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
            .get();
        if (deleteQuery.docs.isNotEmpty) {
          for (var element in deleteQuery.docs) {
            FirebaseFirestore.instance
                .collection('cart')
                .doc(element.id)
                .delete();
          }
        }

        ///---bite_points
        QuerySnapshot zeroHeroesQuery = await FirebaseFirestore.instance
            .collection('zero_heroes')
            .where("uid",
                isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
            .get();
        if (zeroHeroesQuery.docs.isNotEmpty) {
          FirebaseFirestore.instance
              .collection('zero_heroes')
              .doc(zeroHeroesQuery.docs[0].id)
              .update({
            'bite_points': FieldValue.increment(bitePoints!),
          });
        }

        FirebaseFirestore.instance.collection('bite_points').doc().set({
          'uid': Get.find<GeneralController>().boxStorage.read('uid'),
          'points': bitePoints,
          'date_time': DateTime.now(),
        });
        Get.find<HomeLogic>().getCartCount();
      }

      // customConfirmDialog(Get.context!);
      Get.find<GeneralController>().updateFormLoader(false);
    } on FirebaseException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      log(e.toString());
    }
  }

  BuildContext? referenceContext;
  updateReferenceContext(BuildContext newValue) {
    referenceContext = newValue;
    update();
  }

  String? restName;
  String? restTime;
  String? restAddress;
  getData() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('cart')
        .where("uid",
            isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
        .get();
    QuerySnapshot queryForRestImage = await FirebaseFirestore.instance
        .collection('restaurants')
        .where("id", isEqualTo: query.docs[0].get('restaurant_id'))
        .get();
    if (queryForRestImage.docs.isNotEmpty) {
      restName = queryForRestImage.docs[0].get('name');
      restAddress = queryForRestImage.docs[0].get('address');
      restTime =
          '${queryForRestImage.docs[0].get('open_time')} - ${queryForRestImage.docs[0].get('close_time')}';
      update();
    }
  }
}
