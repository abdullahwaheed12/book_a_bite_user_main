import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentState {
  TextStyle? appBarTextStyle;
  TextStyle? buttonTextStyle;
  TextStyle? headingTextStyle;
  TextStyle? titleTextStyle;

  PaymentState() {
    ///Initialize variables
    appBarTextStyle = GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor);
    buttonTextStyle = GoogleFonts.nunito(
        fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white);
    headingTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w900, color: customTextGreyColor);
    titleTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black);
  }
  
}
