import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../provider/pro_provider.dart';
Padding chatTop(BuildContext context) {

  var pro = Provider.of<ProfileProvider>(context, listen: false);
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: 30.sp),
    child: SizedBox(
      height: 40.h,
      width: 400.w,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "Massage",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),

        ],
      ),
    ),
  );
}