import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpState {
  TextStyle? labelTextStyle;
  TextStyle? buttonTextStyle;
  TextStyle? doNotTextStyle;
  TextStyle? registerTextStyle;
  SignUpState() {
    ///Initialize variables
    labelTextStyle = GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w900,
        color: Colors.black.withOpacity(0.4));
    buttonTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white);
    doNotTextStyle = GoogleFonts.nunito(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black38);
    registerTextStyle = GoogleFonts.nunito(
        fontSize: 15, fontWeight: FontWeight.normal, color: customThemeColor);
  }
}
