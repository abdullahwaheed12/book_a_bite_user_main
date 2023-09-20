import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingReviewState {
  TextStyle? headingTextStyle;
  TextStyle? nameTextStyle;
  TextStyle? priceTextStyle;
  TextStyle? otpTextStyle;
  TextStyle? appBarTextStyle;
  TextStyle? swipeTextStyle;
  PendingReviewState() {
    ///Initialize variables
    headingTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w800, fontSize: 20, color: customTextGreyColor);
    nameTextStyle = GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w700, color: customTextGreyColor);
    priceTextStyle = GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: customTextGreyColor.withOpacity(0.5));
    otpTextStyle = GoogleFonts.nunito(
        fontSize: 11, fontWeight: FontWeight.w600, color: customTextGreyColor);
    appBarTextStyle = GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor);
    swipeTextStyle = GoogleFonts.nunito(
        fontSize: 10, fontWeight: FontWeight.w700, color: customTextGreyColor);
  }
}
