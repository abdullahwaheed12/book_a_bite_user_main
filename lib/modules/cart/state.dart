import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartState {
  TextStyle? appBarTextStyle;
  TextStyle? swipeTextStyle;
  TextStyle? productNameTextStyle;
  TextStyle? productPriceTextStyle;
  TextStyle? productQuantityTextStyle;
  TextStyle? billValueTextStyle;
  TextStyle? billLabelTextStyle;
  TextStyle? discountPercentTextStyle;
  TextStyle? grandTotalTextStyle;
  TextStyle? buttonTextStyle;
  TextStyle? billLabelTextStyleWithCustomColor;
  CartState() {
    ///Initialize variables
    appBarTextStyle = GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor);
    swipeTextStyle = GoogleFonts.nunito(
        fontSize: 10, fontWeight: FontWeight.w700, color: customTextGreyColor);
    productNameTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w600, color: customTextGreyColor);
    productPriceTextStyle = GoogleFonts.nunito(
        fontSize: 15, fontWeight: FontWeight.w700, color: customTextGreyColor);
    productQuantityTextStyle = GoogleFonts.nunito(
        fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white);
    billValueTextStyle = GoogleFonts.nunito(
        fontSize: 15, fontWeight: FontWeight.w700, color: customTextGreyColor);
    billLabelTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w900, color: customTextGreyColor);
    discountPercentTextStyle = GoogleFonts.nunito(
        fontSize: 15, fontWeight: FontWeight.w700, color: Colors.green);
    grandTotalTextStyle = GoogleFonts.nunito(
        fontSize: 25, fontWeight: FontWeight.w900, color: customThemeColor);
    buttonTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white);
    billLabelTextStyleWithCustomColor = GoogleFonts.nunito(
        fontSize: 15, fontWeight: FontWeight.w700, color: customThemeColor);
  }
}
