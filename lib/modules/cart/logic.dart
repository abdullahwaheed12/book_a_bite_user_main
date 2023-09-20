import 'dart:developer';

import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'state.dart';

class CartLogic extends GetxController {
  final state = CartState();

  bool? radioValue = false;
  bool? isBringYourOwnBag = false;

  double? totalPrice = 0;
  double? totalDiscount = 0;
  double? netPrice = 0;
  double? grandTotal = 0;
  double? couponDiscount = 0;
  bool? showBill = false;
  bool? hideCharity = false;
  DocumentSnapshot<Object?>? couponDocumentSnapshot;

  getTotalBillOfCart() async {
    totalPrice = 0;
    totalDiscount = 0;
    netPrice = 0;
    grandTotal = 0;
    showBill = false;
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('cart')
        .where("uid",
            isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
        .get();

    if (query.docs.isNotEmpty) {
      for (var element in query.docs) {
        totalPrice = ((double.parse(element.get('original_price').toString()) *
                int.parse(element.get('quantity').toString())) +
            totalPrice!).toPrecision(2);
        totalDiscount = (((double.parse(element.get('original_price').toString()) -
            double.parse(element.get('dis_price').toString())) *
                int.parse(element.get('quantity').toString())) +
            totalDiscount!).toPrecision(2);
        netPrice = ((double.parse(element.get('dis_price').toString()) *
                int.parse(element.get('quantity').toString())) +
            netPrice!).toPrecision(2);
      }
      grandTotal = netPrice!;
      // grandTotal = netPrice! + 1;
      showBill = true;
      update();
    } else {
      totalPrice = 0;
      totalDiscount = 0;
      netPrice = 0;
      grandTotal = 0;
      showBill = false;
      update();
    }
  }

  DocumentReference? couponDocumentReference;

  makeCouponUsed() async {
    if (couponDocumentReference != null) {
      DocumentSnapshot couponDocumentSnapshot =
          await couponDocumentReference!.get();
      Map<String, dynamic> couponData =
          couponDocumentSnapshot.data() as Map<String, dynamic>;
      if (couponData != null) {
        int userUsageLimit = int.parse(couponData['usageLimit'].toString());

        await couponDocumentReference!
            .set({'status': 'used', 'usageLimit': '${++userUsageLimit}'});
        return;
      }
      await couponDocumentReference!.set({'status': 'used', 'usageLimit': '1'});
      log("makeCouponUsed USED");
      return;
    }
    log("makeCouponUsed NOT USED");
  }
 
}
