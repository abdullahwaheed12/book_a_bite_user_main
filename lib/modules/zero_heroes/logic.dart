import 'dart:developer';

import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'state.dart';

class ZeroHeroesLogic extends GetxController {
  final state = ZeroHeroesState();

  int? myBitePoints;
  int? total;
  bool? loader = true;
  // will initialize the above values
  getBitePoints() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('zero_heroes')
        .where('uid',
            isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
        .get();
    if (query.docs.isNotEmpty) {

      myBitePoints = int.parse(query.docs[0].get('bite_points').toString());
      total = int.parse(query.docs[0].get('bite_points').toString()) ~/ 500;
      loader = false;
      update();
      log('TOTAL BADGES--->>$total');
    }
  }
}
