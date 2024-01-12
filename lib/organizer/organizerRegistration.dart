import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/organizer/organizerLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrgRegistration extends StatefulWidget {
  const OrgRegistration({Key? key});

  @override
  State<OrgRegistration> createState() => _OrgRegistrationState();
}

class _OrgRegistrationState extends State<OrgRegistration> {
  var username = TextEditingController();
  var phonenumber = TextEditingController();
  var email = TextEditingController();
  var idnumber = TextEditingController();
  var department = TextEditingController();
  var password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 14.h),
              SizedBox(
                height: 110.h,
                width: 110.w,
                child: Image.asset('assets/image 1.png'),
              ),
              SizedBox(height: 40.h),
              Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFF204563),
                    fontSize: 30.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField2(
                        controller: username,
                        title: 'Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Empty field';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 22.h),
                      CustomTextField2(
                        controller: phonenumber,
                        keyboardType: TextInputType
                            .number, // Specify TextInputType.number
                        title: 'Phone No',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Empty field';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 22.h),
                      CustomTextField2(
                        controller: email,
                        title: 'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Empty field';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 22.h),
                      CustomTextField2(
                        controller: department,
                        title: 'Department',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Empty field';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 22.h),
                      CustomTextField2(
                        controller: idnumber,
                        title: 'ID Number',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Empty field';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 22.h),
                      CustomTextField2(
                        controller: password,
                        title: 'Password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Empty field';
                          }
                          // Add password validation if needed
                          return null;
                        },
                      ),
                      SizedBox(height: 22.h),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          minimumSize:
                              MaterialStateProperty.all(Size(350.w, 50.h)),
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF204563)),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            _addToOrganiserCollection();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return OrganizerLogin();
                              }),
                            );
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToOrganiserCollection() {
    String userName = username.text;
    String phoneNumber = phonenumber.text;
    String emailAddress = email.text;
    String idNumber = idnumber.text;
    String userPassword = password.text;
    String userDepartment = department.text;

    CollectionReference organiserCollection =
        FirebaseFirestore.instance.collection('organiser');

    organiserCollection.add({
      'name': userName,
      'phonenumber': phoneNumber,
      'email': emailAddress,
      'idnumber': idNumber,
      'password': userPassword,
      'department': userDepartment,
    }).then((value) {
      print('Organizer added to Firestore');
      showToast('Organizer registered successfully!');
    }).catchError((error) {
      print('Failed to add organizer: $error');
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
}

class CustomTextField2 extends StatelessWidget {
  final TextEditingController controller;
  final String? title;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType; // Add this line

  const CustomTextField2({
    Key? key,
    required this.controller,
    this.title,
    this.validator,
    this.keyboardType, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title!),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType, // Add this line
            validator: validator,
            decoration: InputDecoration(
              hintText: title,
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
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
        ],
      ),
    );
  }
}
