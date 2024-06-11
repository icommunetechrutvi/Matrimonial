import 'package:flutter/material.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:overlay_support/overlay_support.dart';

class AppTheme {
  static TextStyle profileEdit(
      [double? size, Color? color, TextDecoration? decoration]) {
    return TextStyle(
        decoration: decoration,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: FontName.poppinsRegular);
  }


  static TextStyle letterText(
      double size, Color color, FontWeight fontWeight, FontStyle fontStyle) {
    return TextStyle(
      fontSize: size,
      fontWeight: fontWeight,
      color: Color.fromARGB(255, 0, 0, 0),
      fontStyle: fontStyle, /*fontFamily: FontName.Helvetica*/
    );
  }
  static TextStyle nextBold(
      [double? size, TextDecoration? decoration]) {
    return TextStyle(
        decoration: decoration,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColor.mainText,
        fontFamily: FontName.poppinsRegular);
  }
  static TextStyle buttonBold(
      [double? size, TextDecoration? decoration]) {
    return TextStyle(
        decoration: decoration,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColor.white,
        fontFamily: FontName.poppinsRegular);
  }
  static TextStyle profileText(
      [double? size,  TextDecoration? decoration]) {
    return TextStyle(
        decoration: decoration,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,);
  }
  static TextStyle profileTexts(
      [double? size,  TextDecoration? decoration]) {
    return TextStyle(
        decoration: decoration,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color:Color.fromARGB(255, 137, 137, 137),
        fontFamily: FontName.poppinsRegular);
  }

  static TextStyle profileDetail(
      [double? size,  TextDecoration? decoration]) {
    return TextStyle(
        decoration: decoration,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color:Color.fromARGB(255, 0, 0, 0),
        fontFamily: FontName.poppinsRegular);
  }
  static TextStyle wishListView(
      [double? size,  TextDecoration? decoration]) {
    return TextStyle(
        decoration: decoration,
        // fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
        // color:Color.fromARGB(255, 212, 174, 176),
        fontFamily: FontName.poppinsRegular);
  }

  static TextStyle nameText(
      [double? size,  TextDecoration? decoration]) {
    return TextStyle(
        decoration: decoration,
        fontSize: 23,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: FontName.poppinsRegular,);
  }
  static TextStyle profileEditText(
      [double? size,  TextDecoration? decoration]) {
    return TextStyle(
      decoration: decoration,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColor.appGreenColor,);
  }
  static TextStyle profileEditLabel(
      [double? size,  TextDecoration? decoration]) {
    return TextStyle(
      decoration: decoration,
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.black,);
  }
  static TextStyle tabText(
      [double? size,  TextDecoration? decoration]) {
    return TextStyle(
      decoration: decoration,
      fontSize: 15,
      fontWeight: FontWeight.bold,
      fontFamily: FontName.poppinsRegular,
      color: Colors.black,);
  }
  static TextStyle tabNameText(
      [double? size,  TextDecoration? decoration]) {
    return TextStyle(
      decoration: decoration,
      fontWeight: FontWeight.bold,
      fontSize: 19,
      fontFamily: FontName.poppinsRegular,
      color: Colors.black,);
  }

  static TextStyle matriId(
      [double? size,  TextDecoration? decoration]) {
    return TextStyle(
      decoration: decoration,
      fontWeight: FontWeight.w900,
      fontSize: 16,
      color:Color.fromARGB(255, 94, 40, 67),);
  }
  static BoxDecoration ConDecoration(
      [double? size, Color? color, TextDecoration? decoration]) {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Colors.white,
        width: 1.0,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      boxShadow: const [
        BoxShadow(
          blurRadius: 5,
          color: Colors.black,
          offset: Offset(1, 2),
        )
      ],);
  }

  static BoxDecoration editProfileDec(
      [double? size, Color? color, TextDecoration? decoration]) {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Colors.white,
        width: 1.0,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      boxShadow: const [
        BoxShadow(
          blurRadius: 5,
          color: Colors.black,
          offset: Offset(1, 1),
        )
      ],);
  }

  static showAlert(String message) {
    showSimpleNotification(
        Text(
          message,
          style:
          const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        background: AppColor.alert,
        foreground:AppColor.alert,
        slideDismiss: true,
        duration: const Duration(seconds: 3));
  }
  static showInvalidAlert(String message) {
    showSimpleNotification(
        Text(
          message,
          style:
          const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        background: AppColor.red,
        foreground:AppColor.red,
        slideDismiss: true,
        duration: const Duration(seconds: 3));
  }



  static InkWell container(String text, BuildContext context, Function onTapd) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        onTapd();
      },
      child: Container(
        height: screenheight>600?65:90,
        width: screenWidth>600?18:40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 0.90,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          gradient: const LinearGradient(
            // tileMode: TileMode.repeated,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 250, 211, 37),
              Color.fromARGB(255, 250, 211, 37),
              Color.fromARGB(255, 250, 211, 37),
              // Color.fromARGB(255, 164, 107, 63),
              // Color.fromARGB(255, 255, 187, 79),
              // Color.fromARGB(255, 255, 255, 255),
              // Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: Center(
          child: Text(
            style: TextStyle(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.w600),
            text,
          ),
        ),
      ),
    );
  }

  static BoxDecoration boxDec(
      Border border, BorderRadius borderRadius, Gradient gradient,
      {bool? isFromTab}) {
    return BoxDecoration(
        borderRadius: borderRadius, border: border, gradient: gradient);
  }

  static Icons commonIcon(
    double size,
    Color color,
  ) {
    return commonIcon(
      size,
      color,
    );
  }

}
class FontName {
  static final poppinsRegular = "poppinsRegular";
}
