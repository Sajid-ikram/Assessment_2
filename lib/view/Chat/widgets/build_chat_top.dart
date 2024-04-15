import 'package:assessment_2/holding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../provider/chat_provider.dart';


Padding buildChatTop(BuildContext context,String name,String url,
    {bool? isFromNotification}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 30.sp),
    child: SizedBox(
      height: 50.h,
      width: 400.w,
      child: Row(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Provider.of<ChatProvider>(context,listen: false).chatId = "";
              if(isFromNotification == null){
                Navigator.of(context).pop();
              }else{
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HoldingPage()));
              }

            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.arrow_back_ios,
                size: 26.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          url != ""
              ? CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 18.sp,
            backgroundImage: NetworkImage(
              url,
            ),
          )
              : CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 18.sp,
            backgroundImage: const AssetImage("assets/profile.png"),
          ),
          SizedBox(width: 10.w),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}