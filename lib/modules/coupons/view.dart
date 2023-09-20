import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'logic.dart';
import 'state.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({Key? key}) : super(key: key);

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final CouponsLogic logic = Get.put(CouponsLogic());
  final CouponsState state = Get.find<CouponsLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    logic.getAllCoupons();
  }

  @override
  Widget build(BuildContext context) {
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
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 15,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Coupons',
            style: state.appBarTextStyle,
          ),
        ),
        body: GetBuilder<CouponsLogic>(
          builder: (data) {
            return data.docsList != null && data.docsList!.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: data.docsList!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: customThemeColor.withOpacity(0.19),
                                      blurRadius: 40,
                                      spreadRadius: 0,
                                      offset: const Offset(
                                          0, 22), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: ListTile(
                                    leading: Image.asset(
                                      'assets/icon.png',
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data.docsList![index]
                                                      .get('discountMethod')
                                                      .toString() ==
                                                  'Flat Discount'
                                              ? '\$${data.docsList![index].get('discount')} off'
                                              : '${data.docsList![index].get('discount')}% off',
                                          style: state.titleTextStyle,
                                        ),
                                        Text(
                                          'Code: ${data.docsList![index].get('discountCouponCode')}',
                                          style: state.subTitleTextStyleGreen,
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      '${data.docsList![index].get('message')}',
                                      style: state.subTitleTextStyle,
                                    ),
                                  )),
                            ),
                          );
                        }),
                  )
                :  Column(
                            children: [
                              const SizedBox(
                                height: 30.0,
                              ),
                              Image.asset(
                                'assets/coupon_emoji.png',
                                width: MediaQuery.of(context).size.width * .8,
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                'ohh snap!  No offers yet',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 28,
                                    color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Looks like you don’t have any active offers available currently. You will be notified once you have a coupon to unlock!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      color: customTextGreyColor),
                                ),
                              ),
                            ],
                          );
   
          },
        ));
  }
}
                     