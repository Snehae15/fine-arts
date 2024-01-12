import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtons extends StatelessWidget {
  final String text;
  final bool? value;
  final Color buttonColor;
  final double textSize;
  final void Function()? onpressed;

  const CustomButtons(
      {required this.text,
      this.value,
      this.onpressed,
      required this.buttonColor,
      required this.textSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r))),
                minimumSize: MaterialStatePropertyAll(Size(350.w, 60.h)),
                backgroundColor: MaterialStatePropertyAll(buttonColor)),
            onPressed: onpressed,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: textSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ))
      ],
    );
  }
}
