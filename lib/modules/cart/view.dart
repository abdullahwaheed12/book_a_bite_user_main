import 'dart:developer';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:book_a_bite_user/modules/cart/coupan_dialog.dart';
import 'package:book_a_bite_user/modules/home/logic.dart';
import 'package:book_a_bite_user/modules/payment/view.dart';
import 'package:book_a_bite_user/utils/colors.dart';
import 'package:book_a_bite_user/widgets/custom_dialog.dart';
import 'package:book_a_bite_user/widgets/custom_dotted_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'logic.dart';
import 'state.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartLogic logic = Get.put(CartLogic());
  final CartState state = Get.find<CartLogic>().state;
  String couponCode = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logic.getTotalBillOfCart();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartLogic>(
      builder: (_cartLogic) => Scaffold(
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
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 15,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Cart',
            style: state.appBarTextStyle,
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              ///---swipe-indication
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/iwwa_swipe.svg',
                    width: MediaQuery.of(context).size.width * .08,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'swipe on an item to delete',
                    style: state.swipeTextStyle,
                  )
                ],
              ),

              ///---cart-list
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream:
                      FirebaseFirestore.instance.collection('cart').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Record not found',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        );
                      } else {
                        return StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                            //inner stream builder
                            stream: FirebaseFirestore.instance
                                .collection('wishList')
                                .where('uid',
                                    isEqualTo: Get.find<GeneralController>()
                                        .boxStorage
                                        .read('uid'))
                                .snapshots(),
                            builder: (context, snapshotInner) {
                              if (snapshotInner.hasData) {
                                return FadedSlideAnimation(
                                  beginOffset: const Offset(0, 0.3),
                                  endOffset: const Offset(0, 0),
                                  slideCurve: Curves.linearToEaseOut,
                                  child: Column(
                                    children: List.generate(
                                        snapshot.data!.docs.length, (index) {
                                      checkWishList(bool? newValue) {
                                        setState(() {});
                                      }

                                      var data = snapshotInner.data!.docs;
                                      var wId = '';
                                      var productId = '';
                                      var favourites = false;
                                      for (var wishItem in data) {
                                        wId = wishItem.data()['w_id'];
                                        print(
                                            'data----------------- ${wishItem.data()}');
                                        if (wId ==
                                            snapshot.data!.docs[index]
                                                .get('product_id')) {
                                          favourites = true;
                                        }
                                      }
                                      print(
                                          '-----------------------${data.length}');

                                      if (snapshot.data!.docs[index]
                                              .get('uid') ==
                                          Get.find<HomeLogic>()
                                              .currentUserData!
                                              .get('uid')) {
                                        return GestureDetector(
                                          onHorizontalDragDown: (e) {
                                            log('Dragged');
                                            Get.find<GeneralController>()
                                                .checkWishList(
                                                    context,
                                                    snapshot.data!.docs[index]
                                                        .get('product_id'),
                                                    checkWishList);
                                          },
                                          child: Slidable(
                                            endActionPane: ActionPane(
                                              motion: const StretchMotion(),
                                              children: [
                                                //!=======================================================================
                                                InkWell(
                                                  onTap: () {
                                                    if (!favourites) {
                                                      log('$favourites');
                                                      Get.find<
                                                              GeneralController>()
                                                          .addToWishList(
                                                              context,
                                                              snapshot.data!
                                                                  .docs[index]
                                                                  .get(
                                                                      'product_id'),
                                                              snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .get(
                                                                              'name') ==
                                                                      ''
                                                                  ? 'biteBags'
                                                                  : 'products');
                                                      setState(() {
                                                        favourites = true;
                                                      });
                                                    } else {
                                                      print('delete');
                                                      Get.find<
                                                              GeneralController>()
                                                          .deleteWishList(
                                                              context,
                                                              snapshot.data!
                                                                  .docs[index]
                                                                  .get(
                                                                      'product_id'));
                                                      setState(() {
                                                        favourites = false;
                                                      });
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        customThemeColor,
                                                    child: Icon(
                                                      favourites
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: Colors.white,
                                                      size: 25,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .03,
                                                ),

                                                InkWell(
                                                  onTap: () {
                                                    FirebaseFirestore.instance
                                                        .collection('cart')
                                                        .doc(snapshot.data!
                                                            .docs[index].id)
                                                        .delete();
                                                    _cartLogic
                                                        .getTotalBillOfCart();

                                                    Get.find<HomeLogic>()
                                                        .getCartCount();
                                                  },
                                                  child: const CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor: Colors.red,
                                                    child: Icon(
                                                      Icons.delete_forever,
                                                      color: Colors.white,
                                                      size: 25,
                                                    ),
                                                  ),
                                                ),
                                                // ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 7, 15, 23),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(19),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: customThemeColor
                                                          .withOpacity(0.19),
                                                      blurRadius: 40,
                                                      spreadRadius: 0,
                                                      offset: const Offset(0,
                                                          15), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Row(
                                                    children: [
                                                      ///---image
                                                      Container(
                                                        height: 80,
                                                        width: 80,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color:
                                                                    Colors.grey,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                          child: snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .get(
                                                                          'name') ==
                                                                  ''
                                                              ? Image.asset(
                                                                  'assets/bite-bag-full.png',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.network(
                                                                  '${snapshot.data!.docs[index].get('image')}',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                        ),
                                                      ),

                                                      ///---detail
                                                      Expanded(
                                                          child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ///---name
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                        snapshot.data!.docs[index].get('name') ==
                                                                                ''
                                                                            ? 'Bite Bag'
                                                                            : '${snapshot.data!.docs[index].get('name')}',
                                                                        style: state
                                                                            .productNameTextStyle),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            15),
                                                                    child: Text(
                                                                        '${snapshot.data!.docs[index].get('discount')}% off',
                                                                        style: GoogleFonts.nunito(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: customGreenColor)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .01,
                                                              ),

                                                              ///---price
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ///---original-price
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child: Text(
                                                                          '\$${snapshot.data!.docs[index].get('original_price')}',
                                                                          style: state
                                                                              .productPriceTextStyle!
                                                                              .copyWith(decoration: TextDecoration.lineThrough)),
                                                                    ),
                                                                  ),

                                                                  ///---dis_price
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child: Text(
                                                                          '\$${snapshot.data!.docs[index].get('dis_price')}',
                                                                          style: state
                                                                              .productPriceTextStyle!
                                                                              .copyWith(color: customThemeColor)),
                                                                    ),
                                                                  ),

                                                                  ///---quantity
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            70,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(19),
                                                                            color: customThemeColor),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              2,
                                                                              0,
                                                                              2),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  if (int.parse(snapshot.data!.docs[index].get('quantity').toString()) > 1) {
                                                                                    FirebaseFirestore.instance.collection('cart').doc(snapshot.data!.docs[index].id).update({
                                                                                      'quantity': FieldValue.increment(-1),
                                                                                    });
                                                                                    _cartLogic.getTotalBillOfCart();
                                                                                  }
                                                                                },
                                                                                child: const Padding(
                                                                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                                                  child: Icon(
                                                                                    Icons.remove,
                                                                                    color: Colors.white,
                                                                                    size: 10,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text('${snapshot.data!.docs[index].get('quantity')}', style: state.productPriceTextStyle!.copyWith(color: Colors.white)),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  if (int.parse(snapshot.data!.docs[index].get('quantity').toString()) < int.parse(snapshot.data!.docs[index].get('max_quantity').toString())) {
                                                                                    FirebaseFirestore.instance.collection('cart').doc(snapshot.data!.docs[index].id).update({
                                                                                      'quantity': FieldValue.increment(1),
                                                                                    });
                                                                                    _cartLogic.getTotalBillOfCart();
                                                                                  }
                                                                                },
                                                                                child: const Padding(
                                                                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                                                  child: Icon(
                                                                                    Icons.add,
                                                                                    color: Colors.white,
                                                                                    size: 10,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    }),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            });
                      }
                    } else {
                      return Text(
                        'Record not found',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      );
                    }
                  }),

              _cartLogic.showBill!
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height * .44,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(32))),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _cartLogic.showBill!
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Checkbox(
                                            activeColor: customThemeColor,
                                            value: _cartLogic.radioValue,
                                            onChanged: (value) {
                                              _cartLogic.radioValue = value;
                                              _cartLogic.update();
                                            }),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'BYOC (Bring Your Own Container)',
                                            maxLines: 2,
                                            style: GoogleFonts.nunito(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900,
                                                color: customGreenColor),
                                          ),
                                          Text(
                                            '(Get 2 Extra BitePoints)',
                                            style: GoogleFonts.nunito(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: customTextGreyColor),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 8,
                            ),
                            // bring your own bag
                            _cartLogic.showBill!
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom:8.0),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                              activeColor: customThemeColor,
                                              value: _cartLogic.isBringYourOwnBag,
                                              onChanged: (value) {
                                                _cartLogic.isBringYourOwnBag =
                                                    value;
                                                _cartLogic.update();
                                              }),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'BYOB (Bring Your Bag)',
                                            maxLines: 2,
                                            style: GoogleFonts.nunito(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900,
                                                color: customGreenColor),
                                          ),
                                          Text(
                                            '(Get 2 Extra BitePoints)',
                                            style: GoogleFonts.nunito(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: customTextGreyColor),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 8,
                            ),

                            ///---total-price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Price',
                                  style: state.billLabelTextStyle,
                                ),
                                Text(
                                  '\$${_cartLogic.totalPrice}',
                                  style: state.billValueTextStyle,
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            ///---total-discount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Discount',
                                      style: state.billLabelTextStyle,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '${((double.parse(_cartLogic.totalDiscount.toString()) / double.parse(_cartLogic.totalPrice.toString())) * 100).toPrecision(2)}%',
                                      style: state.discountPercentTextStyle,
                                    ),
                                  ],
                                ),
                                Text(
                                  '\$${_cartLogic.totalDiscount}',
                                  style: state.billValueTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                       
                            ///---donation-price
                            _cartLogic.hideCharity!
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Charity Partner Donation',
                                            style: state.billLabelTextStyle,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _cartLogic.hideCharity = false;
                                                // _cartLogic.grandTotal =
                                                //     _cartLogic.grandTotal! + 1;
                                              });
                                            },
                                            child: Text(
                                              'Add',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '\$0',
                                        style: state.billValueTextStyle,
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Charity Partner Donation',
                                            style: state.billLabelTextStyle,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _cartLogic.hideCharity = true;
                                                // _cartLogic.grandTotal =
                                                //     _cartLogic.grandTotal! - 1;
                                              });
                                            },
                                            child: Text(
                                              'Remove',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '\$1',
                                        style: state.billValueTextStyle,
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 15,
                            ),

                            ///---coupon discount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Coupon discount',
                                  style: state.billLabelTextStyle,
                                ),
                                Text(
                                  '\$${_cartLogic.couponDiscount}',
                                  style: state.billValueTextStyle,
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 8,
                            ),
                            MySeparator(
                              color: customTextGreyColor.withOpacity(0.3),
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                            ///---use a coupon
                            InkWell(
                              onTap: () {
                                Get.bottomSheet(CoupanDialog(),
                                    isScrollControlled: true);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      'assets/coupn.svg',
                                      width: 20,
                                      height: 20,
                                      color: customThemeColor,
                                    ),
                                  ),
                                  Text(
                                    'Use a Coupon',
                                    style:
                                        state.billLabelTextStyleWithCustomColor,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            MySeparator(
                              color: customTextGreyColor.withOpacity(0.3),
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                            ///---grand-total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Grand Total',
                                  style: state.grandTotalTextStyle,
                                ),
                                Text(
                                  '\$${_cartLogic.hideCharity! ? _cartLogic.grandTotal! - _cartLogic.couponDiscount! : _cartLogic.grandTotal! - _cartLogic.couponDiscount! + 1}',
                                  style: state.grandTotalTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            ///---button
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PaymentPage(
                                    coupanDocumentSnapshot:
                                        _cartLogic.couponDocumentSnapshot,
                                  );
                                }));
                              },
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: customThemeColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Text(
                                    'Proceed to Payment',
                                    style: state.buttonTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
