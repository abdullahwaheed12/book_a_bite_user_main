import 'dart:developer';

import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:book_a_bite_user/modules/home/wigdets/bite_bag_widget.dart';
import 'package:book_a_bite_user/modules/home/wigdets/bite_hub_widget.dart';
import 'package:book_a_bite_user/modules/home/wigdets/bites_widget.dart';
import 'package:book_a_bite_user/modules/home/wigdets/filtered_bites_widget.dart';
import 'package:book_a_bite_user/modules/search/view.dart';
import 'package:book_a_bite_user/route_generator.dart';
import 'package:book_a_bite_user/utils/colors.dart';
import 'package:book_a_bite_user/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'logic.dart';
import 'state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final HomeLogic logic = Get.find<HomeLogic>();
  final HomeState state = Get.find<HomeLogic>().state;
  final _generalController = Get.find<GeneralController>();

  bool? showBiteBag = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    Get.find<HomeLogic>().updateToken();
    Get.find<HomeLogic>().requestLocationPermission(context);
    logic.currentUser(context);

    logic.getCartCount();
    logic.getData();
  }

  List<int> check = [];
  List<int> check2 = [];

  TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      body: Stack(
        children: [
          ///---gradient
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                customThemeColor.withOpacity(0.3),
                customThemeColor.withOpacity(0.8),
                customThemeColor
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )),
          ),

          ///---main
          GetBuilder<HomeLogic>(
            builder: (_homeLogic) => AdvancedDrawer(
              // disabledGestures: true,
              backdropColor: Colors.transparent,
              controller: _homeLogic.advancedDrawerController,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              childDecoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              drawer: const MyCustomDrawer(),
              child: GestureDetector(
                onTap: () {
                  _generalController.focusOut(context);
                },
                child: Scaffold(
                  drawerEnableOpenDragGesture: false,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    leading: InkWell(
                      onTap: () {
                        _homeLogic.handleMenuButtonPressed();
                      },
                      child: ValueListenableBuilder<AdvancedDrawerValue>(
                        valueListenable: _homeLogic.advancedDrawerController,
                        builder: (_, value, __) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 5, 5),
                            child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: value.visible
                                    ? const Icon(
                                        Icons.arrow_back,
                                        size: 25,
                                        color: customTextGreyColor,
                                      )
                                    : SvgPicture.asset(
                                        'assets/drawerIcon.svg')),
                          );
                        },
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      InkWell(
                        onTap: () async {
                          Get.toNamed(PageRoutes.cart);
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 15, 30, 5),
                              child:
                                  SvgPicture.asset('assets/shopping-cart.svg'),
                            ),
                            _homeLogic.totalCartCount == null
                                ? const SizedBox()
                                : Positioned(
                                    top: 5,
                                    right: 12,
                                    child: CircleAvatar(
                                      backgroundColor: customThemeColor,
                                      radius: 10,
                                      child: Text(
                                        '${_homeLogic.totalCartCount}',
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: 10),
                                      ),
                                    ))
                          ],
                        ),
                      )
                    ],
                  ),
                 
                  body: ListView(
                    controller: _homeLogic.scrollController,
                    children: [
                      ///---heading
                      Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                          child: Text("Delicious\nbites for you",
                              style: state.homeHeadingTextStyle)),

                      ///---search-bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
                        child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(200),
                                boxShadow: [
                                  BoxShadow(
                                    color: customThemeColor.withOpacity(0.19),
                                    blurRadius: 40,
                                    spreadRadius: 0,
                                    offset: const Offset(
                                        0, 15), // changes position of shadow
                                  ),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(const SearchPage());
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.search,
                                            color: customThemeColor,
                                            size: 25,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            'Search',
                                            style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.w700,
                                                color: customThemeColor
                                                    .withOpacity(0.5),
                                                fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      customFilterDialog(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: SvgPicture.asset(
                                          'assets/Filter Icon.svg'),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),

                      ///---bite-bag
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Bite Bags",
                                    style: state.homeSubHeadingTextStyle)
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          _homeLogic.biteBagLoader
                              ? Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          18, 5, 0, 5),
                                      child: SizedBox(
                                        height: 145,
                                        width: 120,
                                        child: SkeletonLoader(
                                          period: const Duration(seconds: 2),
                                          highlightColor: Colors.grey,
                                          direction: SkeletonDirection.ltr,
                                          builder: Container(
                                            height: 145,
                                            width: 110,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const BiteBagWidget(),
                       
                        ],
                      ),

                      ///---tabs
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Center(
                          child: DefaultTabController(
                              length: 2, // length of tabs
                              initialIndex: 0,
                              child: TabBar(
                                controller: tabController,
                                isScrollable: true,
                                labelStyle: GoogleFonts.nunito(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                                labelColor: Colors.white,
                                unselectedLabelColor: customThemeColor,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: customThemeColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xffFFA404)
                                          .withOpacity(0.19),
                                      blurRadius: 40,
                                      spreadRadius: 0,
                                      offset: const Offset(
                                          0, 22), // changes position of shadow
                                    ),
                                  ],
                                ),

                                onTap: (int? currentIndex) {
                                  setState(() {
                                    check2 = [];
                                  });
                                  _homeLogic.updateTabIndex(currentIndex);
                                },
                                //TABS USED
                                tabs: [
                                  SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: const Center(
                                      child: Text(
                                        'Bites',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: const Center(
                                      child: Text(
                                        'Bite Hubs',
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),

                      ///---tab-views
                      _homeLogic.tabIndex == 0
                          ? _homeLogic.filterList!.isNotEmpty
                              ? _homeLogic.filteredBiteLoader
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 30, 15, 0),
                                      child: SkeletonLoader(
                                        period: const Duration(seconds: 2),
                                        highlightColor: Colors.grey,
                                        direction: SkeletonDirection.ltr,
                                        builder: Container(
                                          height: 120,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    )
                                  : const FilteredBitesWidget()
                              : _homeLogic.biteLoader
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 30, 15, 0),
                                      child: SkeletonLoader(
                                        period: const Duration(seconds: 2),
                                        highlightColor: Colors.grey,
                                        direction: SkeletonDirection.ltr,
                                        builder: Container(
                                          height: 120,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    )
                                  : const BitesWidget()
                          : _homeLogic.biteHubLoader
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                  child: SkeletonLoader(
                                    period: const Duration(seconds: 2),
                                    highlightColor: Colors.grey,
                                    direction: SkeletonDirection.ltr,
                                    builder: Container(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                )
                              : const BiteHubWidget(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 10,
            left: (MediaQuery.of(context).size.width / 2) -
                (MediaQuery.of(context).size.width * .3 / 2),
            child: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: Get.find<HomeLogic>().advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: value.visible
                      ? const SizedBox()
                      : SafeArea(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(PageRoutes.map);
                            },
                            child: Container(
                              height: 44,
                              width: MediaQuery.of(context).size.width * .3,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: customThemeColor.withOpacity(0.19),
                                      blurRadius: 40,
                                      spreadRadius: 0,
                                      offset: const Offset(
                                          0, 15), // changes position of shadow
                                    ),
                                  ]),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/homeLocationIcon.svg'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Map',
                                      style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18,
                                          color: customThemeColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
       
        ],
      ),
    );
  }

  distanceCalculator() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('restaurants')
        .where('id', isEqualTo: '')
        .get();
    double distanceInMeters = Geolocator.distanceBetween(
        Get.find<HomeLogic>().latitude!,
        Get.find<HomeLogic>().longitude!,
        double.parse(query.docs[0].get('lat').toString()),
        double.parse(query.docs[0].get('lng').toString()));
    log('DISTANCE--->>>${distanceInMeters / 1000}');
    (distanceInMeters ~/ 1000);
    setState(() {});
  }

  customFilterDialog(BuildContext context) {
    return showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
        transitionBuilder: (BuildContext context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: GetBuilder<HomeLogic>(
                builder: (_homeLogic) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///---header
                      Container(
                        height: 66,
                        decoration: BoxDecoration(
                          color: const Color(0xffFFA500).withOpacity(.21),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 10, 15, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Search Type',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: customTextGreyColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      ///---body
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                        child: Column(
                          children: [
                            ///---Vegan
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    activeColor: customThemeColor,
                                    value: _homeLogic.filterVegRadioGroupValue,
                                    onChanged: (bool? value) {
                                      _homeLogic.filterVegRadioGroupValue =
                                          value;
                                      _homeLogic.update();
                                      if (value!) {
                                        _homeLogic
                                            .updateFilterRadioValue('Vegan');
                                      } else {
                                        if (_homeLogic.filterList!
                                            .contains('Vegan')) {
                                          int i = _homeLogic.filterList!
                                              .indexOf('Vegan');
                                          _homeLogic.filterList!.removeAt(i);
                                        }
                                      }
                                    }),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Vegan',
                                  style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: customTextGreyColor),
                                )
                              ],
                            ),

                            ///---Vegetarian
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    activeColor: customThemeColor,
                                    value:
                                        _homeLogic.filterNonVegRadioGroupValue,
                                    onChanged: (bool? value) {
                                      _homeLogic.filterNonVegRadioGroupValue =
                                          value;
                                      _homeLogic.update();
                                      if (value!) {
                                        _homeLogic.updateFilterRadioValue(
                                            'Vegetarian');
                                      } else {
                                        if (_homeLogic.filterList!
                                            .contains('Vegetarian')) {
                                          int i = _homeLogic.filterList!
                                              .indexOf('Vegetarian');
                                          _homeLogic.filterList!.removeAt(i);
                                        }
                                      }
                                    }),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Vegetarian',
                                  style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: customTextGreyColor),
                                )
                              ],
                            ),

                            ///---Dairy Free
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    activeColor: customThemeColor,
                                    value: _homeLogic
                                        .filterDiaryFreeRadioGroupValue,
                                    onChanged: (bool? value) {
                                      _homeLogic
                                              .filterDiaryFreeRadioGroupValue =
                                          value;
                                      _homeLogic.update();
                                      if (value!) {
                                        _homeLogic.updateFilterRadioValue(
                                            'Dairy Free');
                                      } else {
                                        if (_homeLogic.filterList!
                                            .contains('Dairy Free')) {
                                          int i = _homeLogic.filterList!
                                              .indexOf('Dairy Free');
                                          _homeLogic.filterList!.removeAt(i);
                                        }
                                      }
                                    }),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Dairy Free',
                                  style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: customTextGreyColor),
                                )
                              ],
                            ),

                            ///---nut-free
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    activeColor: customThemeColor,
                                    value:
                                        _homeLogic.filterNutFreeRadioGroupValue,
                                    onChanged: (bool? value) {
                                      _homeLogic.filterNutFreeRadioGroupValue =
                                          value;
                                      _homeLogic.update();
                                      if (value!) {
                                        _homeLogic
                                            .updateFilterRadioValue('Nut Free');
                                      } else {
                                        if (_homeLogic.filterList!
                                            .contains('Nut Free')) {
                                          int i = _homeLogic.filterList!
                                              .indexOf('Nut Free');
                                          _homeLogic.filterList!.removeAt(i);
                                        }
                                      }
                                    }),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Nut Free',
                                  style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: customTextGreyColor),
                                )
                              ],
                            ),

                            ///---Gluten Free
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    activeColor: customThemeColor,
                                    value: _homeLogic
                                        .filterGlutenFreeRadioGroupValue,
                                    onChanged: (bool? value) {
                                      _homeLogic
                                              .filterGlutenFreeRadioGroupValue =
                                          value;
                                    
                                      _homeLogic.update();
                                      if (value!) {
                                        _homeLogic.updateFilterRadioValue(
                                            'Gluten Free');
                                      } else {
                                        if (_homeLogic.filterList!
                                            .contains('Gluten Free')) {
                                          int i = _homeLogic.filterList!
                                              .indexOf('Gluten Free');
                                          _homeLogic.filterList!.removeAt(i);
                                        }
                                      }
                                    }),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Gluten Free',
                                  style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: customTextGreyColor),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      ///---footer
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  _homeLogic.filterVegRadioGroupValue = false;
                                  _homeLogic.filterNonVegRadioGroupValue =
                                      false;
                                  _homeLogic.filterDiaryFreeRadioGroupValue =
                                      false;
                                  _homeLogic.filterNutFreeRadioGroupValue =
                                      false;
                                  _homeLogic.filterGlutenFreeRadioGroupValue =
                                      false;
                                  _homeLogic.filterList!.clear();
                                  _homeLogic.update();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      child: Text(
                                        'Reset',
                                        style: GoogleFonts.jost(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                            color: customTextGreyColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {});
                                  _homeLogic.filteredBiteLoader = true;
                                  _homeLogic.update();
                                  _homeLogic.getFilteredBites();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: customThemeColor,
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      child: Text(
                                        'Apply',
                                        style: GoogleFonts.jost(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
