import 'package:assessment_2/view/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

Widget roundedButton(String text) {
  return Container(
    margin: EdgeInsets.only(right: 2.w),
    height: 50.sp,
    width: double.infinity,
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
        child: Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,

      ),
    )),
  );
}
