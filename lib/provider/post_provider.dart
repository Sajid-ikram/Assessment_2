
import 'package:assessment_2/provider/pro_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class PostProvider with ChangeNotifier {
  bool isLoading = false;
  bool isLoveLoading = false;
  bool loadingComment = false;
  String commentText = '';
  bool isNewPostAdded = false;

  changeCommentText(String text) {
    commentText = text;
    notifyListeners();
  }



  Future addNewPost({
    required String userName,
    required String productName,
    required String productDescription,
    required String imageUrl,
    required String price,
    required String dateTime,
    required BuildContext context,
  }) async {
    try {
      print("Adding new post ----------------------------------------- ");
      FirebaseFirestore.instance.collection("posts").doc().set(
        {
          "userName": userName,
          "productName": productName,
          "productDescription": productDescription,
          "imageUrl": imageUrl,
          "dateTime": dateTime,
          "price": price,
          "ownerUid": FirebaseAuth.instance.currentUser!.uid,
        },
      );

      print("done Adding new post ----------------------------------------- ");
      isNewPostAdded = !isNewPostAdded;
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future updatePost({
    required String postText,
    required String id,
    required String imageUrl,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection("posts").doc(id).update(
        {
          "postText": postText,
          "imageUrl": imageUrl,
        },
      );
      isNewPostAdded = !isNewPostAdded;
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future<bool> isAlreadyLiked({
    required String postId,
    required String uid,
  }) async {
    DocumentSnapshot thoseWhoLike = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection("thoseWhoLike")
        .doc(uid)
        .get();

    if (thoseWhoLike.exists) {
      return true;
    } else {
      return false;
    }
  }





  Future deletePost(String id) async {
    await FirebaseFirestore.instance.collection("posts").doc(id).delete();
    notifyListeners();
  }
}
