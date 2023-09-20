import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeState {
  TextStyle? drawerTitleTextStyle;
  TextStyle? homeHeadingTextStyle;
  TextStyle? homeSubHeadingTextStyle;
  TextStyle? biteBagTitleTextStyle;
  TextStyle? biteBagPriceTextStyle;
  TextStyle? nameTextStyle;
  TextStyle? priceTextStyle;
  HomeState() {
    ///Initialize variables
    drawerTitleTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white);
    homeHeadingTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w800, fontSize: 34, color: customTextGreyColor);
    homeSubHeadingTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w700, fontSize: 17, color: customThemeColor);
    biteBagTitleTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w700, fontSize: 18, color: customTextGreyColor);
    biteBagPriceTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w700, fontSize: 12, color: customThemeColor);
    nameTextStyle = GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w700, color: customTextGreyColor);
    priceTextStyle = GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: customTextGreyColor.withOpacity(0.5));
  }
}
