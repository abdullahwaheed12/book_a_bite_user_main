import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CouponsState {
  TextStyle? appBarTextStyle;
  TextStyle? titleTextStyle;
  TextStyle? subTitleTextStyle;
  TextStyle? subTitleTextStyleGreen;
  CouponsState() {
    ///Initialize variables
    appBarTextStyle = GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor);
    titleTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w700, color: customThemeColor);
    subTitleTextStyle = GoogleFonts.nunito(
        fontSize: 11, fontWeight: FontWeight.w600, color: customTextGreyColor);
    subTitleTextStyleGreen = GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.w900, color: customDialogErrorColor);

  }
}
