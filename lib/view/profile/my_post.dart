import 'dart:ui';
import 'package:assessment_2/provider/post_provider.dart';
import 'package:assessment_2/view/home/user_info_of_a_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import '../Home/add_sell_post_page.dart';
import '../utils/custom_loading.dart';

enum WhyFarther { delete, edit }

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  int size = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Posts",
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.add),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Align(
          alignment: Alignment.bottomCenter,
          child: Consumer<PostProvider>(
            builder: (context, provider, child) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .orderBy('dateTime', descending: true)
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
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),

                    itemBuilder: (context, index) {

                      return Container(
                        width: 350.w,
                        margin: EdgeInsets.fromLTRB(32.w, 10.h, 32.w, 10.h),
                        padding: EdgeInsets.fromLTRB(20.w, 21.h, 5, 20.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xffE3E3E3), width: 1),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                UserInfoOfAPost(
                                  uid: data?.docs[index]["ownerUid"],
                                  time: data?.docs[index]["dateTime"],
                                ),

                                  Positioned(
                                    right: 0,
                                    child: PopupMenuButton<WhyFarther>(
                                      icon: const Icon(Icons.more_horiz),
                                      padding: EdgeInsets.zero,
                                      onSelected: (WhyFarther result) {
                                        if (result == WhyFarther.delete) {
                                          _showMyDialog(context,
                                              data?.docs[index].id ?? "");
                                        } else if (result == WhyFarther.edit) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddNewPostPage(
                                                documentSnapshot:
                                                    data?.docs[index],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<WhyFarther>>[
                                        const PopupMenuItem<WhyFarther>(
                                          value: WhyFarther.delete,
                                          child: Text('Delete'),
                                        ),
                                        const PopupMenuItem<WhyFarther>(
                                          value: WhyFarther.edit,
                                          child: Text('Edit'),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                            SizedBox(height: 18.h),
                            Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Name : ${data?.docs[index]["productName"]}",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.inter(
                                      fontSize: 15.sp, height: 1.4),
                                ),
                              ),
                            ),

                            SizedBox(height: 10.h),Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Price : ${data?.docs[index]["price"]}",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.inter(
                                      fontSize: 15.sp, height: 1.4),
                                ),
                              ),
                            ),

                            SizedBox(height: 10.h),
                            ExpandableText(
                              data?.docs[index]["productDescription"],
                              trimType: TrimType.characters,
                              trim: 100, //
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.inter(

                                  fontSize: 15.sp, height: 1.4,color: Colors.black),// trims if text exceeds 20 characters
                            ),

                            if (data?.docs[index]["imageUrl"] != "")
                              SizedBox(height: 15.h),
                            if (data?.docs[index]["imageUrl"] != "")
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return PhotoView(
                                        imageProvider: NetworkImage(
                                            data?.docs[index]["imageUrl"]),
                                      );
                                    }),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 226.h,
                                  padding: EdgeInsets.only(right: 15.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      data?.docs[index]["imageUrl"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    itemCount: size,
                  );
                },
              );
            },
          )),
    );
  }
}

Future<void> _showMyDialog(BuildContext context, String id) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Notice'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Do you want to delete this notice'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Provider.of<PostProvider>(context, listen: false).deletePost(id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
