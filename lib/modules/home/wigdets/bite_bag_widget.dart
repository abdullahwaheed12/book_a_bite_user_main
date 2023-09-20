import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:book_a_bite_user/modules/home/logic.dart';
import 'package:book_a_bite_user/modules/product_detail/view.dart';
import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BiteBagWidget extends StatefulWidget {
  const BiteBagWidget({Key? key}) : super(key: key);

  @override
  _BiteBagWidgetState createState() => _BiteBagWidgetState();
}

class _BiteBagWidgetState extends State<BiteBagWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
      builder: (_homeLogic) => FadedSlideAnimation(
        child: Container(
          color: Colors.transparent,
          height: 235,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _homeLogic.customBiteBageDocument.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    Get.to(ProductDetailPage(
                      isProduct: false,
                      productModel: _homeLogic
                          .customBiteBageDocument[index].customDocumentSnapshot,
                      index: index,
                      imageForBag:
                          "${_homeLogic.customBiteBageDocument[index].customDocShow['image']}",
                    ));
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        18,
                        57,
                        index == _homeLogic.customBiteBageDocument.length - 1
                            ? 18
                            : 0,
                        5),
                    child: Stack(
                      // ignore: deprecated_member_use
                      // overflow: Overflow.visible,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 25),
                          width: 117,
                          height: 137,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: customThemeColor.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 0,
                                offset: const Offset(
                                    0, 10), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    "${_homeLogic.customBiteBageDocument[index].customDocShow['restaurant']}",
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        _homeLogic.state.biteBagTitleTextStyle),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${_homeLogic.customBiteBageDocument[index].customDocShow['quantity']} left",
                                        style: _homeLogic
                                            .state.biteBagTitleTextStyle!
                                            .copyWith(fontSize: 12)),
                                    const Spacer(),
                                    Text(
                                        "${_homeLogic.customBiteBageDocument[index].customDocShow['distance']}km",
                                        style: _homeLogic
                                            .state.biteBagTitleTextStyle!
                                            .copyWith(fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        "\$${_homeLogic.customBiteBageDocument[index].customDocShow['dis_price']}",
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: _homeLogic
                                            .state.biteBagPriceTextStyle),
                                    const Spacer(),
                                    Text(
                                        "\$${_homeLogic.customBiteBageDocument[index].customDocShow['original_price']}",
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: _homeLogic
                                            .state.biteBagPriceTextStyle!
                                            .copyWith(
                                                color: customTextGreyColor,
                                                decoration: TextDecoration
                                                    .lineThrough)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                    "${_homeLogic.customBiteBageDocument[index].customDocShow['discount']}% off",
                                    style: _homeLogic
                                        .state.biteBagPriceTextStyle!
                                        .copyWith(color: Colors.green)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            right: 15.5,
                            top: -65,
                            child: Hero(
                              tag: "assets/Group 97.png$index",
                              child: Material(
                                color: Colors.transparent,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 80,
                                      child: Image.asset(
                                        "assets/bite-bag.png",
                                        height: 100,
                                        width: 80,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      width: 80,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.network(
                                                "${_homeLogic.customBiteBageDocument[index].customDocShow['image']}",
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              }),
        ),
        beginOffset: const Offset(0.3, 0.2),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
