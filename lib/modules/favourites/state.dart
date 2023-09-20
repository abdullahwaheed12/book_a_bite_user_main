import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouritesState {
  TextStyle? appBarTextStyle;
  TextStyle? swipeTextStyle;

  FavouritesState() {
    ///Initialize variables
    appBarTextStyle = GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor);
    swipeTextStyle = GoogleFonts.nunito(
        fontSize: 10, fontWeight: FontWeight.w700, color: customTextGreyColor);
  }
}
