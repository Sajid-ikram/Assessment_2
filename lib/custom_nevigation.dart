import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:assessment_2/view/Chat/chat_view.dart';
import 'package:assessment_2/view/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'View/Home/home.dart';
import 'View/utils/app_colors.dart';

class CustomNavigation extends StatefulWidget {
  const CustomNavigation({Key? key}) : super(key: key);

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  int _bottomNavIndex = 0;

  List<IconData> icons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.comment,
    FontAwesomeIcons.gear,
  ];

  List<Widget> pages = [
    const Home(),
    const ChatView(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: pages[_bottomNavIndex],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        shadow: BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, -15),
            blurRadius: 10),
        icons: icons,
        notchSmoothness: NotchSmoothness.softEdge,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.none,
        iconSize: 19.sp,
        inactiveColor: Colors.grey,
        activeColor: primaryColor,
        leftCornerRadius: 40.sp,
        rightCornerRadius: 40.sp,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }
}
