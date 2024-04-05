import 'package:assessment_2/view/Auth/widgets/round_button.dart';
import 'package:assessment_2/view/Auth/widgets/snackBar.dart';
import 'package:assessment_2/view/Auth/widgets/switch_page.dart';
import 'package:assessment_2/view/Auth/widgets/text_field.dart';
import 'package:assessment_2/view/utils/custom_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Provider/authentication.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fcodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    fcodeController.clear();
    super.dispose();
  }

  validate() async {

    if (_formKey.currentState!.validate()) {
      try {
        if (confirmPasswordController.text != passwordController.text) {
          snackBar(context, "Password does not match");
          return;
        }
        buildLoadingIndicator(context);
        Provider.of<Authentication>(context, listen: false)
            .signUp(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          fCode: fcodeController.text.isEmpty ? "" : fcodeController.text,
          context: context,
        )
            .then((value) async {
          if (value != "Success") {
            snackBar(context, value);
          } else {
            final User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              user.sendEmailVerification();
            }
          }
        });
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBar(context, "Some error occur");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(30.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 45.h),
              SizedBox(
                height: 180.h,
                child: Image.asset("assets/signup.jpg"),
              ),
              SizedBox(height: 40.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    customTextField(nameController, "Full name", context,
                        Icons.person_outline_rounded),
                    SizedBox(height: 20.h),
                    customTextField(emailController, "UWL Email", context,
                        Icons.email_outlined),
                    SizedBox(height: 20.h),
                    customTextField(passwordController, "Password", context,
                        Icons.lock_outline_rounded),
                    SizedBox(height: 20.h),
                    customTextField(
                        confirmPasswordController,
                        "Confirm Password",
                        context,
                        Icons.lock_outline_rounded),
                    SizedBox(height: 20.h),
                    switchPageButton(
                        "Already Have An Account? ", "Log In", context),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  validate();
                },
                child: roundedButton("Register"),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}