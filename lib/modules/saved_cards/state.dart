import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedCardsState {
  TextStyle? headingTextStyle;
  TextStyle? updateButtonStyle;
  SavedCardsState() {
    ///Initialize variables
    headingTextStyle = GoogleFonts.nunito(
        fontSize: 34, fontWeight: FontWeight.w800, color: customThemeColor);
    updateButtonStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white);
  }
}
