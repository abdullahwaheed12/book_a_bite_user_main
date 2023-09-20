import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailState {
  TextStyle? productNameStyle;
  TextStyle? restaurantNameStyle;
  TextStyle? productPriceStyle;
  TextStyle? productDescStyle;
  TextStyle? cartButtonStyle;
  TextStyle? headingTextStyle;
  TextStyle? descTextStyle;

  ProductDetailState() {
    ///Initialize variables
    productNameStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w800, fontSize: 28, color: customTextGreyColor);
    restaurantNameStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w800, fontSize: 18, color: customThemeColor);
    productPriceStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white);
    productDescStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w400, fontSize: 15, color: customTextGreyColor);
    cartButtonStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white);
    headingTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w900, fontSize: 17, color: customTextGreyColor);
    descTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w600, fontSize: 15, color: customTextGreyColor);
  }
}
