// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo_locator;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:system_settings/system_settings.dart';

import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:book_a_bite_user/utils/colors.dart';

import 'state.dart';

class HomeLogic extends GetxController {
  final state = HomeState();

  bool? biteBagLoadCheck = false;
  updateBiteBagLoadCheck(bool? newValue) {
    biteBagLoadCheck = newValue;
    update();
  }

  DocumentSnapshot? currentUserData;
  currentUser(BuildContext context) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where("uid",
            isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
        .get();

    if (query.docs.isNotEmpty) {
      log('USER---->>>${query.docs[0].get('name')}');
      if (query.docs[0].get('name').toString() == 'guest' ||
          query.docs[0].get('name').toString() == 'Guest') {
        nameSaveDialog(context, query.docs[0].id);
      }
      currentUserData = query.docs[0];
      update();
    } else {}
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  nameSaveDialog(BuildContext context1, String? id) {
    return showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context1,
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
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
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
                                  'Enter Your Name',
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
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle:
                                GoogleFonts.nunito(color: customThemeColor),
                            border: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customTextGreyColor)),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customTextGreyColor)),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customThemeColor)),
                            errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field Required';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),

                      ///---footer
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 20, 0, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      Get.find<GeneralController>()
                                          .updateFormLoader(true);
                                      Navigator.pop(context);
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(id)
                                          .update(
                                              {'name': nameController.text});
                                    }
                                  },
                                  child: Container(
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: customThemeColor,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Text(
                                          'SAVE',
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  int? totalCartCount;
  getCartCount() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('cart')
        .where("uid",
            isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
        .get();

    if (query.docs.isNotEmpty) {
      totalCartCount = query.docs.length;
      update();
    } else {
      totalCartCount = null;
      update();
    }
  }

  AdvancedDrawerController advancedDrawerController =
      AdvancedDrawerController();
  void handleMenuButtonPressed() {
    advancedDrawerController.showDrawer();
    update();
  }

  ScrollController scrollController = ScrollController();

  int? tabIndex = 0;
  updateTabIndex(int? newValue) {
    tabIndex = newValue;
    update();
  }

  // String? filterString;
  List? filterList = [];
  bool? filterRadioValue = false;
  bool? filterVegRadioGroupValue = false;
  bool? filterNonVegRadioGroupValue = false;
  bool? filterDiaryFreeRadioGroupValue = false;
  bool? filterNutFreeRadioGroupValue = false;
  bool? filterGlutenFreeRadioGroupValue = false;
  updateFilterRadioValue(String? newValue) {
    filterList!.add(newValue!);

    update();
  }

  getData() {
    if (Get.find<GeneralController>().boxStorage.hasData('preferences')) {
      filterList = Get.find<GeneralController>().boxStorage.read('preferences');
      filteredBiteLoader = true;
      update();
      getFilteredBites();
      if (filterList!.contains('Veg')) {
        filterVegRadioGroupValue = true;
      }
      if (filterList!.contains('Non-Veg')) {
        filterNonVegRadioGroupValue = true;
      }
      if (filterList!.contains('Diary Free')) {
        filterDiaryFreeRadioGroupValue = true;
      }
      if (filterList!.contains('Nut Free')) {
        filterNutFreeRadioGroupValue = true;
      }
    }
    update();
  }

  ///----bite-bag
  bool biteBagLoader = true;

  List<CustomDocument> customBiteBageDocument = [];

  getBiteBag() async {
    customBiteBageDocument.clear();
    QuerySnapshot<Map<String, dynamic>> queryBiteBag =
        await FirebaseFirestore.instance.collection('biteBags').get();
    for (var element in queryBiteBag.docs) {
      QuerySnapshot<Map<String, dynamic>> queryRestaurant =
          await FirebaseFirestore.instance
              .collection('restaurants')
              .where('id', isEqualTo: element.get('restaurant_id'))
              .get();
      if (queryRestaurant.docs.isNotEmpty) {
        if (queryRestaurant.docs[0].get('isActive').toString() == 'true' &&
            int.parse(element.get('quantity').toString()) > 0) {
          int? distance = (geo_locator.Geolocator.distanceBetween(
                  Get.find<HomeLogic>().latitude!,
                  Get.find<HomeLogic>().longitude!,
                  double.parse(queryRestaurant.docs[0].get('lat').toString()),
                  double.parse(
                      queryRestaurant.docs[0].get('lng').toString())) ~/
              1000);

          customBiteBageDocument.add(CustomDocument(
              customDocumentSnapshot: element,
              customDocShow: {
                'image': element.get('image'),
                'restaurant': element.get('restaurant'),
                'quantity': element.get('quantity'),
                'distance': distance,
                'original_price': element.get('original_price'),
                'discount': element.get('discount'),
                'dis_price': element.get('dis_price'),
              }));
        }
      }
    }
   

    customBiteBageDocument.sort(mySortComparison);
    
    update();
    biteBagLoader = false;
    update();
  }

  int mySortComparison(CustomDocument a, CustomDocument b) {
    final propertyA = a.customDocShow['distance'];
    final propertyB = b.customDocShow['distance'];
    if (propertyA < propertyB) {
      return -1;
    } else if (propertyA > propertyB) {
      return 1;
    } else {
      return 0;
    }
  }

  ///----bite-hub
  bool biteHubLoader = true;
 
  List<CustomDocument> customBiteHubDocument = [];

  getBiteHub() async {
    customBiteHubDocument.clear();
    QuerySnapshot queryBiteHub =
        await FirebaseFirestore.instance.collection('restaurants').get();
    for (var element in queryBiteHub.docs) {
      if (element.get('isActive').toString() == 'true') {
        double? avgRating = 0.0;
        List.generate(
            element.get('ratings').length,
            (innerIndex) =>
                avgRating = avgRating! + element.get('ratings')[innerIndex]);
        int? distance = (geo_locator.Geolocator.distanceBetween(
                Get.find<HomeLogic>().latitude!,
                Get.find<HomeLogic>().longitude!,
                double.parse(element.get('lat').toString()),
                double.parse(element.get('lng').toString())) ~/
            1000);
     
        customBiteHubDocument.add(CustomDocument(
            customDocumentSnapshot: element,
            customDocShow: {
              'image': element.get('image'),
              'name': element.get('name'),
              'open_time': element.get('open_time'),
              'close_time': element.get('close_time'),
              'distance': distance,
              'avg_rating': avgRating == 0.0
                  ? 0.0
                  : double.parse(
                          (avgRating! / element.get('total_rates')).toString())
                      .toPrecision(1),
            }));
      }
    }
    customBiteHubDocument.sort((a, b) {
      return a.customDocShow['distance'].compareTo(b.customDocShow['distance']);
    });
    update();
    biteHubLoader = false;
    update();
  }

  ///----bites
  bool biteLoader = true;

  List<CustomDocument> customBiteDocument = [];

  getBites() async {
    customBiteDocument.clear();
    QuerySnapshot queryBites =
        await FirebaseFirestore.instance.collection('products').get();
    for (var element in queryBites.docs) {
      QuerySnapshot queryRestaurant = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('id', isEqualTo: element.get('restaurant_id'))
          .get();
      if (queryRestaurant.docs.isNotEmpty) {
        if (queryRestaurant.docs[0].get('isActive').toString() == 'true' &&
            int.parse(element.get('quantity').toString()) > 0) {
          int? distance = (geo_locator.Geolocator.distanceBetween(
                  Get.find<HomeLogic>().latitude!,
                  Get.find<HomeLogic>().longitude!,
                  double.parse(queryRestaurant.docs[0].get('lat').toString()),
                  double.parse(
                      queryRestaurant.docs[0].get('lng').toString())) ~/
              1000);

          customBiteDocument.add(CustomDocument(
              customDocumentSnapshot: element,
              customDocShow: {
                'image': element.get('image'),
                'name': element.get('name'),
                'quantity': element.get('quantity'),
                'distance': distance,
                'original_price': element.get('original_price'),
                'discount': element.get('discount'),
                'dis_price': element.get('dis_price'),
              }));
          customBiteDocument.sort(mySortComparison);
        }
      }
    }


    update();
    biteLoader = false;
    update();
  }

  ///----filtered-bites
  bool filteredBiteLoader = true;

  List<CustomDocument> customFilteredBites = [];

  getFilteredBites() async {
    customFilteredBites.clear();
    QuerySnapshot queryBites =
        await FirebaseFirestore.instance.collection('products').get();
    for (var bite in queryBites.docs) {
      QuerySnapshot queryRestaurant = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('id', isEqualTo: bite.get('restaurant_id'))
          .get();
      if (queryRestaurant.docs.isNotEmpty) {
        bool? filterCheck = false;
        filterList = filterList!.toSet().toList();
        for (var fileterItem in filterList!) {
          if (bite.get('category').contains(fileterItem)) {
            filterCheck = true;
          } else {
            continue;
          }
        }
        if (queryRestaurant.docs[0].get('isActive').toString() == 'true' &&
            int.parse(bite.get('quantity').toString()) > 0 &&
            filterCheck!) {
          int? distance = (geo_locator.Geolocator.distanceBetween(
                  Get.find<HomeLogic>().latitude!,
                  Get.find<HomeLogic>().longitude!,
                  double.parse(queryRestaurant.docs[0].get('lat').toString()),
                  double.parse(
                      queryRestaurant.docs[0].get('lng').toString())) ~/
              1000);

          customFilteredBites.add(CustomDocument(
              customDocumentSnapshot: bite,
              customDocShow: {
                'image': bite.get('image'),
                'name': bite.get('name'),
                'quantity': bite.get('quantity'),
                'distance': distance,
                'original_price': bite.get('original_price'),
                'discount': bite.get('discount'),
                'dis_price': bite.get('dis_price'),
              }));
          customFilteredBites.sort((a, b) {
            return a.customDocShow['distance']
                .compareTo(b.customDocShow['distance']);
          });
        }
      }
    }

    update();
    filteredBiteLoader = false;
    update();
  }

  ///------------------------------------LOCATION----START-----------------
  geo_locator.Position? currentPosition;
  double? latitude;
  double? longitude;
  String? currentAddress;
  String? currentArea;
  String? currentCity;
  String? currentCountry;

  Future<bool> _requestPermission(Permission permission) async {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  requestLocationPermission(BuildContext context) async {
    if (Platform.isIOS) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.locationWhenInUse,
      ].request();
      var status = await Permission.locationWhenInUse.request();
      var granted = statuses;
      ServiceStatus serviceStatus = await Permission.location.serviceStatus;
      bool enabled = (serviceStatus == ServiceStatus.enabled);

      if (!enabled) {
        getBiteBag();
        getBiteHub();
        getBites();
        log('IOS permission--->> $enabled');
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return CustomDialogBox(
        //         title: '${'location'.tr}!',
        //         titleColor: customDialogInfoColor,
        //         descriptions: 'please_turn_on_your_location'.tr,
        //         text: 'ok'.tr,
        //         functionCall: () {
        //           Navigator.pop(context);
        //           AppSettings.openLocationSettings();
        //         },
        //         img: 'assets/dialog_Info.svg',
        //       );
        //     });
      } else {
        getCurrentLocation();
      }
    } else {
      var granted = await _requestPermission(Permission.location);
      if (granted != true) {
        var granted1 = await _requestPermission(Permission.locationAlways);
        if (granted1 != true) {
          requestLocationPermission(context);
        }
        requestLocationPermission(context);
      } else {
        // _gpsService();
        getCurrentLocation();
      }
      debugPrint('requestLocationPermission $granted');
      return granted;
    }
  }

  getCurrentLocation() {
    geo_locator.Geolocator.getCurrentPosition(
            desiredAccuracy: geo_locator.LocationAccuracy.high)
        .then((geo_locator.Position position) {
      currentPosition = position;
      longitude = currentPosition!.longitude;
      latitude = currentPosition!.latitude;
      log("longitude : $longitude");
      log("latitude : $latitude");
      log("address : $currentPosition");

      getBiteBag();
      getBiteHub();
      getBites();
      update();
      if (currentPosition == null) {
        getCurrentLocation();
      }
      getAddressFromLatLng();
    }).catchError((e) {
      // Get.find<GeneralController>().updateFormLoader(false);
      _gpsService();
      log('ERROR LOCATION${e.toString()}');
    });
  }

  enableLocation() async {
    await SystemSettings.location();
  }

  Future _gpsService() async {
    if (!(await geo_locator.Geolocator.isLocationServiceEnabled())) {
      enableLocation();
      return null;
    } else {
      return true;
    }
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> p = await GeocodingPlatform.instance
          .placemarkFromCoordinates(
              currentPosition!.latitude, currentPosition!.longitude);
      Placemark place = p[0];
      currentAddress =
          '${place.name}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
      // if (addressController.text.isEmpty) {
      //   addressController.text = currentAddress!;
      // }
      currentArea = "${place.thoroughfare}";
      currentCity = place.subAdministrativeArea.toString();
      currentCountry = place.country.toString();
      log('CURRENT-ADDRESS--->>${currentAddress.toString()}');
      log('ADMINISTRATIVE--->>${place.administrativeArea.toString()}');
      log('SUB-ADMINISTRATIVE--->>${place.subAdministrativeArea.toString()}');
      log('SUB-ADMINISTRATIVE--->>${place.country.toString()}');
      log('THROUGH_FAIR--->>${place.thoroughfare.toString()}');
      log('COMPLETE_PLACE--->>${place.toJson().toString()}');
      // Get.find<GeneralController>().updateFormLoader(false);
      update();
    } catch (e) {
      // Get.find<GeneralController>().updateFormLoader(false);
      log(e.toString());
    }
  }

  ///------------------------------------LOCATION----END-----------------

  User? currentUserForFcm;
  String? fcmToken;
  updateToken() async {
    currentUserForFcm = FirebaseAuth.instance.currentUser;
    if (!Get.find<GeneralController>().boxStorage.hasData('fcmToken')) {
      await FirebaseMessaging.instance.getToken().then((value) {
        fcmToken = value;
        Get.find<GeneralController>().boxStorage.write('fcmToken', 'Exist');
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserForFcm!.uid)
          .update({'token': fcmToken});
    }
  }
}

class CustomDocument {
  DocumentSnapshot customDocumentSnapshot;
  Map<String, dynamic> customDocShow;
  CustomDocument({
    required this.customDocumentSnapshot,
    required this.customDocShow,
  });
}
