import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ZeroHeroesState {
  TextStyle? headingTextStyle;
  TextStyle? subHeadingTextStyle;
  TextStyle? captionTextStyle;
  ZeroHeroesState() {
    ///Initialize variables
    headingTextStyle = GoogleFonts.nunito(
        fontSize: 48, fontWeight: FontWeight.w800, color: customThemeColor);
    subHeadingTextStyle = GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: customThemeColor);
    captionTextStyle = GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w700, color: customTextGreyColor);
  }
}
