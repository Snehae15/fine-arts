import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? title;
  final FormFieldValidator? validator;
  final EdgeInsetsGeometry? contentPadding;
  // final bool obscureText;
  final TextEditingController? controller;
  final Color? fillcolor;
  // final bool readonly;
  // final bool? showCursor;
  final void Function()? onTap;
  const CustomTextField(
      {super.key,
      this.hintText,
      this.controller,
      this.onTap,
      this.contentPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
      this.prefixIcon,
      this.suffixIcon,
      // required this.obscureText,
      this.fillcolor,
      // required this.readonly,
      // this.showCursor,
      this.title,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).r,
          child: Container(
            child: TextFormField(
              // controller: controller,
              // validator: validator,
              decoration: InputDecoration(
                prefixIcon: prefixIcon,
                hintText: hintText,
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
          ),
        )
      ],
    );
  }

  CustomTextField loginTextfield(String hintText) {
    return CustomTextField(
      hintText: hintText,
      // key: formKey,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Empty field';
        }
      },
      prefixIcon: Icon(Icons.person),
    );
  }

  CustomTextField passwordTextfield(String hintrText) => CustomTextField(
        hintText: hintrText,
        //  key: formKey,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Empty field';
          }
        },
        prefixIcon: Icon(Icons.lock),
        controller: controller,
      );
}
