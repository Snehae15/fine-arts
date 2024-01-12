import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/student/studenhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'studentregistration.dart';

bool isLoading = false;

class Studentlogin extends StatefulWidget {
  const Studentlogin({Key? key}) : super(key: key);

  @override
  State<Studentlogin> createState() => _StudentloginState();
}

class _StudentloginState extends State<Studentlogin> {
  var user = TextEditingController();
  var password = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
              Center(
                child: Text(
                  'Student Login',
                  style: TextStyle(
                    color: Color(0xFF204563),
                    fontSize: 30.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
              SizedBox(
                height: 74.h,
              ),
              customTextField('Email', user),
              SizedBox(
                height: 20.h,
              ),
              customTextField('Password', password),
              SizedBox(
                height: 30.h,
              ),
              customButton(18.0, "Login"),
              SizedBox(
                height: 50.h,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StdRegister(),
                    ),
                  );
                },
                child: Text(
                  'Create new Account',
                  style: TextStyle(
                    color: Color(0xFF204563),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : Container(), // Loading Indicator
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton customButton(double textSize, String text) => ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          )),
          minimumSize: MaterialStatePropertyAll(Size(350.w, 60.h)),
          backgroundColor: MaterialStatePropertyAll(Color(0xFF204563)),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // Set loading to true before starting the login process
            setState(() {
              isLoading = true;
            });
            validateLogin();
          }
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: textSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  Padding customTextField(String hintText, var controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Empty field';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          hintStyle: TextStyle(
            color: Color(0xFF1A1919),
            fontSize: 15.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }

  void validateLogin() async {
    final String enteredEmail = user.text;
    final String enteredPassword = password.text;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('email', isEqualTo: enteredEmail)
          .where('password', isEqualTo: enteredPassword)
          .where('status', isEqualTo: 'Accepted')
          .get();

      // Set loading to false after the login process is complete
      setState(() {
        isLoading = false;
      });

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id; // Get the Document ID

        // Store Document ID in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('studentId', docId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Studenthome()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Credentials'),
              content: Text('Please enter valid email and password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Set loading to false in case of an error
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }
}
