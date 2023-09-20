import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:get/get.dart';

import 'state.dart';

class PreferencesLogic extends GetxController {
  final state = PreferencesState();
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
}
