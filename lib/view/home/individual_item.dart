import 'package:assessment_2/provider/post_provider.dart';
import 'package:assessment_2/view/home/product_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Widget productCard(
    QuerySnapshot<Object?> data, int index, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(data.docs[index]),
        ),
      );
    },
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Hero(
      tag: data.docs[index].id,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        margin: EdgeInsets.fromLTRB(0, 10, 15, 10),
        decoration: BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
            image: NetworkImage(data.docs[index]["imageUrl"]),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  //height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.docs[index]["productName"],
                          style: GoogleFonts.poppins(
                              color: Color(0xFF628395),
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),

                        Text("Price: £${data.docs[index]["price"].toString()}",
                            style: GoogleFonts.poppins(
                              color: Color(0xFF628395),
                              fontSize: 14,
                            )),
                        //SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
