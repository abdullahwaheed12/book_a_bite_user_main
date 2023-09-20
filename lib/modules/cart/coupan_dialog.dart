import 'dart:developer';

import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:book_a_bite_user/modules/cart/logic.dart';
import 'package:book_a_bite_user/modules/cart/state.dart';
import 'package:book_a_bite_user/utils/colors.dart';
import 'package:book_a_bite_user/widgets/custom_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoupanDialog extends StatefulWidget {
  CoupanDialog({Key? key}) : super(key: key);

  @override
  State<CoupanDialog> createState() => _CoupanDialogState();
}

class _CoupanDialogState extends State<CoupanDialog> {
  final CartLogic logic = Get.put(CartLogic());
  final CartState state = Get.find<CartLogic>().state;
  String couponCode = '';
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartLogic>(builder: (_cartLogic) {
      return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
            color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                "Enter Coupon",
                style: state.grandTotalTextStyle,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  onChanged: (couponCode) {
                    this.couponCode = couponCode;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Coupon",
                    labelStyle: const TextStyle(color: customThemeColor),
                    border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black.withOpacity(0.5))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black.withOpacity(0.5))),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: customThemeColor)),
                    errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () async {
                    if (couponCode.isEmpty) {
                      return;
                    }
                    //-------------
                    _cartLogic.getTotalBillOfCart();

                    Get.find<GeneralController>().focusOut(context);
                    showProgress();
                    //------------- get the valid or unvalid coupon
                    var querySnapshot = await FirebaseFirestore.instance
                        .collection('coupon')
                        .where('discountCouponCode', isEqualTo: couponCode)
                        .where('isValid', isEqualTo: true)
                        .get();

                    //--coupon is valid or not
                    if (querySnapshot.docs.isEmpty) {
                      showToast("Not a valid coupon");
                      dissmissProgress();
                      return;
                    }

                    //get the currently apply coupan code doc snapshot
                    DocumentSnapshot coupondocumentSnapshot =
                        querySnapshot.docs.first;
                    print('');
                    //check for coupan expire validity

                    var date = DateTime.parse(
                        coupondocumentSnapshot.get('validity_date'));

                    if (DateTime.now().compareTo(date) > 0) {
                      showToast("your coupan is expired");
                      Get.back();
                      Get.back();
                      return;
                    }
                    // curently cart item with coupan code
                    var cartQuery = await FirebaseFirestore.instance
                        .collection('cart')
                        .where("uid",
                            isEqualTo: Get.find<GeneralController>()
                                .boxStorage
                                .read('uid'))
                        .where('couponCode', isEqualTo: couponCode)
                        .get();
                    print('111111111111 ${cartQuery.docs.length}');
                    //get the user Doc for this coupon
                    var userUsageDoc = await FirebaseFirestore.instance
                        .collection('coupon')
                        .doc(coupondocumentSnapshot.id)
                        .collection('user')
                        .doc(Get.find<GeneralController>()
                            .boxStorage
                            .read('uid'))
                        .get();
                    log("couponData ");

                    if (userUsageDoc.exists) {
                      var userUsage = userUsageDoc.get('userUsage') as int;

                      print('user usage $userUsage');
                      print(
                          'doc coupon usage ${coupondocumentSnapshot.get('usageLimit')}');

                      if (userUsage <
                          int.parse(coupondocumentSnapshot.get('usageLimit'))) {
                        if (cartQuery.docs.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection('cart')
                              .doc(cartQuery.docs[0].id)
                              .update({'isApplyCoupon': true});
                        } else {
                          print('===============>>>> ${cartQuery.docs.length}');
                          print(
                              'prodcut not added for coupan ${cartQuery.docs.length}');
                          showToast("Add other product for this coupon");
                          dissmissProgress();
                          return;
                        }
                      } else {
                        print('limit up');
                        showToast("your usage limit exceed");
                        dissmissProgress();

                        return;
                      }
                    } else {
                      if (cartQuery.docs.isEmpty) {
                        print(
                            'prodcut not added for coupan ${cartQuery.docs.length}');
                        showToast("Add other product for this coupon");
                        dissmissProgress();
                        return;
                      }
                    }

                    String discountMethod =
                        querySnapshot.docs.first.data()['discountMethod'];
                    double discount = double.parse(
                        querySnapshot.docs.first.data()['discount'].toString());
                    if (discountMethod.contains('Percentage Discount')) {
                      double d = (discount / 100.0).toDouble();
                      double totalDiscount =
                          (double.parse(_cartLogic.grandTotal.toString()) * d)
                              .toDouble();

                      //---------------for coupon discount
                      print(
                          'minAmountValue =============> ${coupondocumentSnapshot.get('minAmountValue')}');
                      print(
                          'minAmountValue =============> ${_cartLogic.totalPrice!}');

                      if (discount.toPrecision(2) >
                              _cartLogic.totalPrice! * 0.8 ||
                          _cartLogic.totalPrice! <
                              int.parse(coupondocumentSnapshot
                                  .get('minAmountValue')) ||
                          cartQuery.docs.isEmpty) {
                        //------------1
                        if (discount.toPrecision(2) >
                            _cartLogic.totalPrice! * 0.8) {
                          showToast(
                              'cart value must be 80% of ${discount.toPrecision(2)}');
                        }
                        //------------2
                        if (_cartLogic.totalPrice! <
                            int.parse(
                                coupondocumentSnapshot.get('minAmountValue'))) {
                          showToast(
                              'cart total price ${_cartLogic.totalPrice} must be greater then ${coupondocumentSnapshot.get('minAmountValue')}');
                        }

                        dissmissProgress();

                        Get.back();
                        return;
                      } else {
                        _cartLogic.couponDocumentSnapshot = userUsageDoc;
                        _cartLogic.couponDiscount =
                            totalDiscount.toPrecision(2);
                        _cartLogic.update();
                      }
                    } else {
                      //---------------for coupon discount
                      print('======================> coupan for flat discount');
                      print(
                          'minAmountValue =============> ${coupondocumentSnapshot.get('minAmountValue')}');
                      print(
                          'minAmountValue =============> ${_cartLogic.totalPrice!}');
                      if (discount.toPrecision(2) >
                              _cartLogic.totalPrice! * 0.8 ||
                          _cartLogic.totalPrice! <
                              int.parse(coupondocumentSnapshot
                                  .get('minAmountValue')) ||
                          cartQuery.docs.isEmpty) {
                        showToast(
                            'minimum cart value must be ${coupondocumentSnapshot.get('minAmountValue')} for this copoun');
                        // showToast(
                        //     'you cannot use this coupan');
                        dissmissProgress();

                        Get.back();
                        return;
                      } else {
                        _cartLogic.couponDocumentSnapshot = userUsageDoc;
                        _cartLogic.couponDiscount = discount.toPrecision(2);
                        _cartLogic.update();
                      }
                    }
                    showToast(_cartLogic.couponDiscount.toString());
                    _cartLogic.update();
                    dissmissProgress();
                    Get.back();
                  },
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: customThemeColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: state.buttonTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}
