import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/student/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StdRegister extends StatefulWidget {
  const StdRegister({Key? key});

  @override
  State<StdRegister> createState() => _StdRegisterState();
}

class _StdRegisterState extends State<StdRegister> {
  final TextEditingController username = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController idnumber = TextEditingController();
  final TextEditingController department = TextEditingController();
  final TextEditingController password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (formKey.currentState!.validate()) {
      try {
        DocumentReference studentRef =
            await FirebaseFirestore.instance.collection('students').add({
          'name': username.text,
          'phoneNumber': phonenumber.text,
          'email': email.text,
          'idNumber': idnumber.text,
          'department': department.text,
          'password': password.text,
          'status': 'pending',
        });

        String studentId = studentRef.id;
        await studentRef.update({'studentId': studentId});
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('studentId', studentId);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Studentlogin()),
        );
      } catch (error) {
        print('Error adding student data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    'Registration',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
                SizedBox(height: 47.h),
                CustomTextField2(
                  controller: username,
                  title: 'Name',
                ),
                SizedBox(height: 22.h),
                CustomTextField2(
                  controller: phonenumber,
                  title: 'Phone No',
                ),
                SizedBox(height: 22.h),
                CustomTextField2(
                  controller: email,
                  title: 'Email',
                ),
                SizedBox(height: 22.h),
                CustomTextField2(
                  controller: idnumber,
                  title: 'ID Number',
                ),
                SizedBox(height: 22.h),
                CustomTextField2(
                  controller: department,
                  title: 'Department',
                ),
                SizedBox(height: 22.h),
                CustomTextField2(
                  controller: password,
                  title: 'Password',
                ),
                Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(350.w, 50.h),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xFF204563),
                    ),
                  ),
                  onPressed: _submitForm,
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
      ),
    );
  }
}

class CustomTextField2 extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const CustomTextField2({
    required this.title,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Empty field';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter $title',
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
