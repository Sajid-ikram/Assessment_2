import 'package:assessment_2/Provider/authentication.dart';
import 'package:flutter/material.dart';

Center customTextField(TextEditingController controller, String text,
    BuildContext context, IconData iconData) {
  return Center(
    child: TextFormField(
      controller: controller,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: text,
        fillColor: Color(0xffC4C4C4).withOpacity(0.2),
        filled: true,
        suffixIcon: Icon(iconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          // Set desired corner radius
          borderSide: BorderSide.none, // Set border color (optional)
        ),
      ),
      validator: (value) {
        if (text == "Full name") {
          if (value != null && value.length > 50) {
            snackBar(context, "Name should be less then 50 character");
            return "Name should be less then 50 character";
          } else if (value == null || value.isEmpty) {
            snackBar(context, "Field can not be empty!");
            return "Field can not be empty!";
          } else if (isNameValid(value)) {
            snackBar(context, "Name should contain only character");
            return "Name should contain only character";
          }
        }
        else if (text == "UWL Email") {
          if (value != null && !value.contains("uwl.ac.uk")) {
            snackBar(context, "You have to use a UWL email");
            return "You have to use a UWL email";
          } else if (value == null || value.isEmpty) {
            snackBar(context, "Field can not be empty!");
            return "Field can not be empty!";
          }
        }
        else if (text == "Password" || text == "Confirm Password") {
          if (value == null || value.isEmpty) {
            snackBar(context, "Field can not be empty!");
            return "Field can not be empty!";
          } else if (value.length < 6) {
            snackBar(context, "Password should be at least 6 character long");
            return "Password should be at least 6 character long";
          }
        } else if (text == "Odesk Code") {
          if (value == null || value.isEmpty) {
            snackBar(context, "Field can not be empty!");
            return "Field can not be empty!";
          }
          return null;
        }
        /*else if (value == null || value.isEmpty) {
          snackBar(context, "Field can not be empty!");
          return "Field can not be empty!";
        }*/
        return null;
      },
      obscureText: text == "Password"|| text == "Confirm Password" ? true : false,
      /*decoration: InputDecoration(
            suffixIcon: Icon(iconData),
            errorStyle: const TextStyle(fontSize: 0.01),
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            hintText: text,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 14.sp,
            ),
          )*/
    ),
  );
}

bool isNameValid(String name) {
  if (name.isEmpty) {
    return false;
  }
  bool hasDigits = name.contains(RegExp(r'[0-9]'));
  bool hasSpecialCharacters = name.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  return hasDigits & hasSpecialCharacters;
}
