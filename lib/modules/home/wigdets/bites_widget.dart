import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:book_a_bite_user/modules/home/logic.dart';
import 'package:book_a_bite_user/modules/product_detail/view.dart';
import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BitesWidget extends StatefulWidget {
  const BitesWidget({Key? key}) : super(key: key);

  @override
  _BitesWidgetState createState() => _BitesWidgetState();
}

class _BitesWidgetState extends State<BitesWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
      builder: (_homeLogic) => FadedSlideAnimation(
        child: SingleChildScrollView(
          child: Wrap(
            children: List.generate(_homeLogic.customBiteDocument.length, (index) {
              print('66666 ${_homeLogic.customBiteDocument.length}');
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                child: InkWell(
                  onTap: () {
                    Get.to(ProductDetailPage(
                      isProduct: true,
                      productModel: _homeLogic.customBiteDocument[index].customDocumentSnapshot,
                    ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(19),
                      boxShadow: [
                        BoxShadow(
                          color: customThemeColor.withOpacity(0.19),
                          blurRadius: 40,
                          spreadRadius: 0,
                          offset:
                              const Offset(0, 22), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          ///---image
                          Hero(
                            tag: '${_homeLogic.customBiteDocument[index].customDocumentSnapshot['image']}',
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: const BoxDecoration(
                                    color: Colors.grey, shape: BoxShape.circle),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.network(
                                    '${_homeLogic.customBiteDocument[index].customDocumentSnapshot['image']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          ///---detail
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ///---name
                                  Text(
                                      '${_homeLogic.customBiteDocument[index].customDocumentSnapshot['name']}',
                                      style: _homeLogic.state.nameTextStyle),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .01,
                                  ),

                                  ///---quantity-discount
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ///---quantity
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              '${_homeLogic.customBiteDocument[index].customDocumentSnapshot['quantity']} left',
                                              style: _homeLogic
                                                  .state.priceTextStyle),
                                        ),
                                      ),

                                      ///---distance
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              '${_homeLogic.customBiteDocument[index].customDocShow['distance']}km',
                                              style: _homeLogic
                                                  .state.priceTextStyle),
                                        ),
                                      ),

                                      ///---price
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              '\$${_homeLogic.customBiteDocument[index].customDocumentSnapshot['original_price']}',
                                              style: _homeLogic
                                                  .state.priceTextStyle!
                                                  .copyWith(
                                                      decoration: TextDecoration
                                                          .lineThrough)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .01,
                                  ),

                                  ///---price
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ///---discount
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              '${_homeLogic.customBiteDocument[index].customDocumentSnapshot['discount']}% off',
                                              style: _homeLogic
                                                  .state.priceTextStyle!
                                                  .copyWith(
                                                      color: Colors.green)),
                                        ),
                                      ),

                                      ///---price
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            width: 70,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(19),
                                                color: customThemeColor),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 2, 0, 2),
                                              child: Center(
                                                child: Text(
                                                    '\$${_homeLogic.customBiteDocument[index].customDocumentSnapshot['dis_price']}',
                                                    style: _homeLogic
                                                        .state.priceTextStyle!
                                                        .copyWith(
                                                            color:
                                                                Colors.white)),
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
              );
            }),
          ),
        ),
        beginOffset: const Offset(0.3, 0.2),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  
  }
}
