import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingReviewState {
  TextStyle? headingTextStyle;
  TextStyle? titleTextStyle;
  TextStyle? buttonTextStyle;
  RatingReviewState() {
    ///Initialize variables
    headingTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w800, fontSize: 28, color: customTextGreyColor);
    titleTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w700, fontSize: 20, color: customTextGreyColor);
    buttonTextStyle = GoogleFonts.nunito(
        fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white);
  }
}
