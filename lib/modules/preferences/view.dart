import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:book_a_bite_user/modules/home/logic.dart';
import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'logic.dart';
import 'state.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final PreferencesLogic logic = Get.put(PreferencesLogic());

  final PreferencesState state = Get.find<PreferencesLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logic.getData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferencesLogic>(
      builder: (_preferencesLogic) => Scaffold(
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
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: ListView(
                children: [
                  ///---heading
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(
                      'Dietary\nPreferences',
                      style: state.headingTextStyle,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Column(
                      children: [
                        ///---Vegan
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                                activeColor: customThemeColor,
                                value:
                                    _preferencesLogic.filterVegRadioGroupValue,
                                onChanged: (bool? value) {
                                  _preferencesLogic.filterVegRadioGroupValue =
                                      value;
                                  _preferencesLogic.update();
                                  if (value!) {
                                    _preferencesLogic
                                        .updateFilterRadioValue('Vegan');
                                  } else {
                                    if (_preferencesLogic.filterList!
                                        .contains('Vegan')) {
                                      int i = _preferencesLogic.filterList!
                                          .indexOf('Vegan');
                                      _preferencesLogic.filterList!.removeAt(i);
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
                                value: _preferencesLogic
                                    .filterNonVegRadioGroupValue,
                                onChanged: (bool? value) {
                                  _preferencesLogic
                                      .filterNonVegRadioGroupValue = value;
                                  _preferencesLogic.update();
                                  if (value!) {
                                    _preferencesLogic
                                        .updateFilterRadioValue('Vegetarian');
                                  } else {
                                    if (_preferencesLogic.filterList!
                                        .contains('Vegetarian')) {
                                      int i = _preferencesLogic.filterList!
                                          .indexOf('Vegetarian');
                                      _preferencesLogic.filterList!.removeAt(i);
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
                                value: _preferencesLogic
                                    .filterDiaryFreeRadioGroupValue,
                                onChanged: (bool? value) {
                                  _preferencesLogic
                                      .filterDiaryFreeRadioGroupValue = value;
                                  _preferencesLogic.update();
                                  if (value!) {
                                    _preferencesLogic
                                        .updateFilterRadioValue('Dairy Free');
                                  } else {
                                    if (_preferencesLogic.filterList!
                                        .contains('Dairy Free')) {
                                      int i = _preferencesLogic.filterList!
                                          .indexOf('Dairy Free');
                                      _preferencesLogic.filterList!.removeAt(i);
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
                                value: _preferencesLogic
                                    .filterNutFreeRadioGroupValue,
                                onChanged: (bool? value) {
                                  _preferencesLogic
                                      .filterNutFreeRadioGroupValue = value;
                                  _preferencesLogic.update();
                                  if (value!) {
                                    _preferencesLogic
                                        .updateFilterRadioValue('Nut Free');
                                  } else {
                                    if (_preferencesLogic.filterList!
                                        .contains('Nut Free')) {
                                      int i = _preferencesLogic.filterList!
                                          .indexOf('Nut Free');
                                      _preferencesLogic.filterList!.removeAt(i);
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
                                value: _preferencesLogic
                                    .filterGlutenFreeRadioGroupValue,
                                onChanged: (bool? value) {
                                  _preferencesLogic
                                      .filterGlutenFreeRadioGroupValue = value;
                                  _preferencesLogic.update();
                                  if (value!) {
                                    _preferencesLogic
                                        .updateFilterRadioValue('Gluten Free');
                                  } else {
                                    if (_preferencesLogic.filterList!
                                        .contains('Gluten Free')) {
                                      int i = _preferencesLogic.filterList!
                                          .indexOf('Gluten Free');
                                      _preferencesLogic.filterList!.removeAt(i);
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
                  )
                ],
              )),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
          child: InkWell(
            onTap: () {
              Get.find<GeneralController>()
                  .boxStorage
                  .write('preferences', _preferencesLogic.filterList);
              _preferencesLogic.filterList;
              Get.back();
              Get.find<HomeLogic>().getData();
              Get.snackbar(
                'Preferences Updated Successfully',
                '',
                colorText: Colors.white,
                backgroundColor: customThemeColor.withOpacity(0.7),
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(15),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              height: 70,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: customThemeColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Text(
                  'Update',
                  style: state.updateButtonStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
