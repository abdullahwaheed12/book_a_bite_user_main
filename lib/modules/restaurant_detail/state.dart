import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantDetailState {
  TextStyle? productNameStyle;
  TextStyle? productPriceStyle;
  TextStyle? productDescStyle;
  TextStyle? cartButtonStyle;
  TextStyle? headingTextStyle;
  TextStyle? descTextStyle;
  TextStyle? nameTextStyle;
  TextStyle? priceTextStyle;
  TextStyle? restaurantInfoLabelTextStyle;
  TextStyle? restaurantInfoValueTextStyle;
  RestaurantDetailState() {
    ///Initialize variables
    productNameStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w800, fontSize: 28, color: customTextGreyColor);
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
    nameTextStyle = GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w700, color: customTextGreyColor);
    priceTextStyle = GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: customTextGreyColor.withOpacity(0.5));
    restaurantInfoLabelTextStyle = GoogleFonts.nunito(
        fontSize: 13, fontWeight: FontWeight.w800, color: customTextGreyColor);
    restaurantInfoValueTextStyle = GoogleFonts.nunito(
        fontSize: 13, fontWeight: FontWeight.w600, color: customTextGreyColor);
  }
}
