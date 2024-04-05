import 'package:assessment_2/view/Auth/registration.dart';
import 'package:assessment_2/view/Auth/signin.dart';
import 'package:assessment_2/view/Auth/verification.dart';
import 'package:assessment_2/view/home/home.dart';
import 'package:assessment_2/view/utils/custom_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class HoldingPage extends StatefulWidget {
  const HoldingPage({Key? key}) : super(key: key);

  @override
  _HoldingPageState createState() => _HoldingPageState();
}

class _HoldingPageState extends State<HoldingPage> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        }
        if (snapshot.data != null && snapshot.data!.emailVerified) {
          return const Home();
        }
        return snapshot.data == null
            ? const SignIn()
            : const Verification();
      },
    );
  }
}