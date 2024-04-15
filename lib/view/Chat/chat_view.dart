import 'package:assessment_2/view/Chat/widgets/chat_user_top.dart';
import 'package:assessment_2/view/Chat/widgets/individual_chat_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/pro_provider.dart';
import '../utils/app_colors.dart';
import '../utils/custom_loading.dart';




class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  int size = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            chatTop(context),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("chatRooms")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return buildLoadingWidget();
                    }

                    final data = snapshot.data;
                    if (data != null) {
                      size = data.size;
                      if (size == 0) {
                        return Center(
                          child: Text(
                            "No chat yet!",
                            style: GoogleFonts.inter(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: primaryColor),
                          ),
                        );
                      }

                      return buildListOfChat(data);
                    } else {
                      return const Center(child: Text("Something went wrong"));
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  ListView buildListOfChat(QuerySnapshot<Object?> data) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        String uid = "";
        bool show = false;
        if (data.docs[index]["user1"] == pro.currentUserUid) {
          uid = data.docs[index]["user2"];
          show = true;
        } else if (data.docs[index]["user2"] == pro.currentUserUid) {
          uid = data.docs[index]["user1"];
          show = true;
        }

        return show && data.docs[index]["lastMassage"] != ""
            ? Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 32.w,vertical: 10.h),
              child: IndividualChatInfo(
                  lastMs: data.docs[index]["lastMassage"], uid: uid),
            ),
            Divider(
              height: 5,
              indent: 32.w,
              endIndent: 32.w,
            ),
          ],
        )
            : const SizedBox();
      },
      itemCount: size,
    );
  }
}
