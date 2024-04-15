import 'package:assessment_2/view/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/pro_provider.dart';
import '../Auth/widgets/snackBar.dart';
import '../Chat/chat.dart';

class ProductDetailPage extends StatefulWidget {
    ProductDetailPage(QueryDocumentSnapshot<Object?> this.doc, {Key? key,}) : super(key: key);

   var doc;

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isLoading = true;
  late DocumentSnapshot data;
  getInfo() async {
    try {
      data = await Provider.of<ProfileProvider>(context, listen: false)
          .getProfileInfoByUID(widget.doc["ownerUid"]);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (err) {
      snackBar(context, "Some error occur");
    }
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: size.height * 1.34,
          width: size.width,
          child: Stack(
            children: [
              Stack(
                children: [
                  Container(
                    height: size.height * 0.6,
                    width: size.width,
                    color: Colors.grey,
                    child: Hero(
                      tag: widget.doc.id,
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: 'assets/profile.jpg',
                        image: widget.doc["imageUrl"],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 33,
                        width: 33,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: size.height * 0.56,
                child: buildProductInfo(size, widget.doc),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildProductInfo(Size size, DocumentSnapshot args) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(args["productName"],
                    style: TextStyle(fontSize: 25, color: primaryColor)),
                Text("\$ ${args["price"]}".toString(),
                    style: TextStyle(fontSize: 25, color: primaryColor)),
              ],
            ),
            Divider(
              thickness: 2,
              color: secondaryColor.withOpacity(0.2),
              endIndent: 40,
              indent: 40,
              height: 60,
            ),
            Text("Product details : ".toString(),
                style: const TextStyle(fontSize: 23)),
            const SizedBox(
              height: 10,
            ),
            Text(args["productDescription"],
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, color: Colors.black)),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Chat(
                          name: data["name"],
                          url: data["url"],
                          token: data["token"],
                          uid: data.id,
                        ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 50,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text("Start Conversation".toString(),
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
