import 'dart:developer';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:book_a_bite_user/modules/home/logic.dart';
import 'package:book_a_bite_user/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'logic.dart';
import 'state.dart';

class ZeroHeroesPage extends StatefulWidget {
  const ZeroHeroesPage({Key? key}) : super(key: key);

  @override
  State<ZeroHeroesPage> createState() => _ZeroHeroesPageState();
}

class _ZeroHeroesPageState extends State<ZeroHeroesPage> {
  final ZeroHeroesLogic logic = Get.put(ZeroHeroesLogic());

  final ZeroHeroesState state = Get.find<ZeroHeroesLogic>().state;

  List<String> badges = [
    'assets/B-1.png',
    'assets/B-2.png',
    'assets/B-3.png',
    'assets/B-4.png',
    'assets/B-5.png',
    'assets/B-6.png',
    'assets/B-7.png',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<ZeroHeroesLogic>().getBitePoints();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ZeroHeroesLogic>(
      builder: (_zeroHeroesLogic) => Scaffold(
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
        ),
        body: _zeroHeroesLogic.loader!
            ? const Center(
                child: CircularProgressIndicator(
                color: customThemeColor,
              ))
            : SafeArea(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Zero Heroes',
                            style: state.headingTextStyle,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Not all heroes wear capes',
                          style: state.captionTextStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
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
                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                              child: _zeroHeroesLogic.total == 0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'No Badge Earned Yet!',
                                          style: state.headingTextStyle!
                                              .copyWith(fontSize: 22),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Accumulate Bite Points with every order and help plant native trees. 1 badge = 1 native NZ tree planted',
                                          textAlign: TextAlign.center,
                                          style: state.captionTextStyle!
                                              .copyWith(fontSize: 15),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Image.asset(
                                          _zeroHeroesLogic.total! > 8
                                              ? badges[6]
                                              : badges[
                                                  _zeroHeroesLogic.total! - 1],
                                          width: 100,
                                          height: 100,
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'BITE POINTS',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color:
                                                          customTextGreyColor),
                                                ),
                                                Text(
                                                  '${_zeroHeroesLogic.myBitePoints}',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 38,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: customThemeColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Badges Earned',
                            style: state.subHeadingTextStyle,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              badges.length,
                              (index) => _zeroHeroesLogic.total! >= index + 1
                                  ? Image.asset(
                                      badges[index],
                                      width: 100,
                                      height: 120,
                                    )
                                  : Image.asset(
                                      badges[index],
                                      width: 100,
                                      height: 120,
                                      color: Colors.grey,
                                    )),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .01,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('zero_heroes')
                                    .orderBy('bite_points', descending: true)
                                    .snapshots(),
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
                                      print(snapshot.data!.docs.length);
                                      return FadedSlideAnimation(
                                        child: Wrap(
                                          children: List.generate(
                                              snapshot.data!.docs.length,
                                              (index) {
                                         return  StreamBuilder<
                                                      QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .where('uid',
                                                          isEqualTo: snapshot
                                                              .data!.docs[index]
                                                              .get('uid'))
                                                      .snapshots(),
                                                  builder: (context, snp) {
                                                    if (snp.connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      log('Waiting');
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                18, 5, 0, 5),
                                                        child: SizedBox(
                                                          height: 50,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: SkeletonLoader(
                                                            period:
                                                                const Duration(
                                                                    seconds: 2),
                                                            highlightColor:
                                                                Colors.grey,
                                                            direction:
                                                                SkeletonDirection
                                                                    .ltr,
                                                            builder: Container(
                                                              height: 50,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    } else if (snp.hasData) {
                                                      Map<String, dynamic> map =
                                                          snp
                                                                  .data!.docs[0]
                                                                  .data()
                                                              as Map<String,
                                                                  dynamic>;
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 5, 0, 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height: 50,
                                                              width: 50,
                                                              decoration: map
                                                                      .containsKey(
                                                                          'image')
                                                                  ? snp.data!.docs[0].get('image').toString() ==
                                                                          ''
                                                                      ? BoxDecoration(
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.4),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        )
                                                                      : BoxDecoration(
                                                                          color: Colors.grey.withOpacity(
                                                                              0.4),
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          image:
                                                                              DecorationImage(image: NetworkImage('${snp.data!.docs[0].get('image')}')))
                                                                  : BoxDecoration(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.4),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                '${snp.data!.docs[0].get('name')}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: true,
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color:
                                                                        customTextGreyColor),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 80,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              19)),
                                                              child: Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          0,
                                                                          5,
                                                                          0,
                                                                          5),
                                                                  child: Text(
                                                                    '${snapshot.data!.docs[index].get('bite_points')}',
                                                                    style: GoogleFonts.nunito(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      return const SizedBox();
                                                    }
                                                  });
                                          
                                          }),
                                        ),
                                        beginOffset: const Offset(0.3, 0.2),
                                        endOffset: const Offset(0, 0),
                                        slideCurve: Curves.linearToEaseOut,
                                      );
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
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
