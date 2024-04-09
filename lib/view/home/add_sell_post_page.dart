import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_storage/firebase_storage.dart' as storage;
import '../../provider/post_provider.dart';
import '../../provider/profile_provider.dart';
import '../Auth/registration.dart';
import '../utils/custom_loading.dart';

class AddNewPostPage extends StatefulWidget {
  AddNewPostPage({Key? key, this.documentSnapshot}) : super(key: key);

  DocumentSnapshot? documentSnapshot;

  @override
  _AddNewPostPageState createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {
  final picker = ImagePicker();
  late File _imageFile;
  bool isSelected = false;

  Future pickImage(ImageSource imageSource) async {
    try {
      final pickedFile = await picker.pickImage(
        source: imageSource,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        setState(() {
          isSelected = true;
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {}
  }

  Future addPost() async {
    try {
      buildLoadingIndicator(context);
      String url = "";
      if (isSelected) {
        final ref = storage.FirebaseStorage.instance
            .ref()
            .child("postImage/${DateTime.now()}");

        final result = await ref.putFile(_imageFile);
        url = await result.ref.getDownloadURL();
      }

      var pro = Provider.of<ProfileProvider>(context, listen: false);

      print("Adding new post 1 ----------------------------------------- ");
      Provider.of<PostProvider>(context, listen: false).addNewPost(
          userName: pro.profileName,
          productName: productNameController.text,
          productDescription: productDescriptionController.text,
          imageUrl: url,
          dateTime: DateTime.now().toString(),
          context: context);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {

      print("err  new post ----------------------------------------- ");
      print(e);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future updatePost() async {
    try {
      buildLoadingIndicator(context);
      String url = "";
      if (isSelected) {
        final ref = storage.FirebaseStorage.instance
            .ref()
            .child("postImage/${DateTime.now()}");

        final result = await ref.putFile(_imageFile);
        url = await result.ref.getDownloadURL();
      }

      if (!isSelected &&
          widget.documentSnapshot != null &&
          widget.documentSnapshot!["imageUrl"] != "") {
        url = widget.documentSnapshot!["imageUrl"];
      }

      Provider.of<PostProvider>(context, listen: false).updatePost(
        postText: productDescriptionController.text,
        id: widget.documentSnapshot!.id,
        imageUrl: url,
        context: context,
      );
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  late TextEditingController productDescriptionController;
  late TextEditingController productNameController;

  @override
  void initState() {
    if (widget.documentSnapshot != null) {
      productDescriptionController =
          TextEditingController(text: widget.documentSnapshot!["postText"]);
      productDescriptionController =
          TextEditingController(text: widget.documentSnapshot!["productName"]);
    } else {
      productDescriptionController = TextEditingController();
      productNameController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SizedBox(
        height: 800.h,
        width: 360.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 60.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 30.sp,
                        )),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (widget.documentSnapshot == null) {
                          addPost();
                        } else {
                          updatePost();
                        }
                      },
                      child: SizedBox(
                        width: 100.w,
                        height: 45.h,
                        child: roundedButton("Post"),
                      ),
                    )
                  ],
                ),
              ),
              buildTextField(productNameController, "Product Name"),
              buildTextField(productDescriptionController, "Description", maxLine: 6),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 20.h),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        pickImage(ImageSource.camera);
                      },
                      child: Container(
                        height: 70.h,
                        width: 78.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.camera),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    InkWell(
                      onTap: () {
                        pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        height: 70.h,
                        width: 78.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.image),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                height: 200.h,
                width: 360.w,
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isSelected
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _imageFile,
                          fit: BoxFit.cover,
                        ))
                    : widget.documentSnapshot != null &&
                            widget.documentSnapshot!["imageUrl"] != ""
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.documentSnapshot!["imageUrl"],
                              fit: BoxFit.cover,
                            ))
                        : const Center(
                            child: Text("No Image Selected"),
                          ),
              ),
              SizedBox(height: 25.h),

            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTitleText(String text, double size, double height) {
  return Container(
    alignment: Alignment.centerLeft,
    width: 220,
    child: Text(
      text,
      style: GoogleFonts.poppins(color: Color(0xffFCCFA8), fontSize: size),
    ),
  );
}

Padding buildTextField(TextEditingController controller, String text,
    {int maxLine = 1}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
    child: TextField(
      maxLines: maxLine,
      style: const TextStyle(color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
        fillColor: Color(0xffC4C4C4).withOpacity(0.2),
        filled: true,
        hintText: text,
        hintStyle: GoogleFonts.inter(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          // Set desired corner radius
          borderSide: BorderSide.none, // Set border color (optional)
        ),
      ),
    ),
  );
}
