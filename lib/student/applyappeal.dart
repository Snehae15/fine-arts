import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplyAppeal extends StatefulWidget {
  final String eventId;

  const ApplyAppeal({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<ApplyAppeal> createState() => _ApplyAppealState();
}

class _ApplyAppealState extends State<ApplyAppeal> {
  var username = TextEditingController();
  var videoLink = TextEditingController();
  var department = TextEditingController();
  var description = TextEditingController();

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Apply Appeal',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
      ),
      body: Form(
        key: formkey,
        child: Column(
          children: [
            SizedBox(
              height: 75,
            ),
            Center(child: Image.asset('assets/user2.png')),
            CustomTextField2(
              controller: username,
              Title: 'Name',
            ),
            SizedBox(
              height: 22.h,
            ),
            CustomTextField2(
              controller: videoLink,
              Title: 'Video Link',
            ),
            SizedBox(
              height: 22.h,
            ),
            CustomTextField2(
              controller: department,
              Title: 'Department',
            ),
            SizedBox(
              height: 22.h,
            ),
            CustomTextField2(
              minLines: 6,
              controller: description,
              Title: 'Description',
            ),
            Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                minimumSize: MaterialStatePropertyAll(
                  Size(350.w, 50.h),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  Color(0xFF204563),
                ),
              ),
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  submitAppealData();
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
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  Padding CustomTextField2(
      {String? Title, String? hintText, var controller, int? minLines}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Title!),
          TextFormField(
            minLines: minLines,
            maxLines: minLines,
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Empty field';
              }
            },
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
              ).r,
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

  void submitAppealData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String studentId = prefs.getString('studentId') ?? '';

      if (studentId.isEmpty) {
        print('Student ID is empty');
        return;
      }

      String userName = username.text;
      String userVideoLink = videoLink.text;
      String userDepartment = department.text;
      String userDescription = description.text;

      print('Submitting appeal for studentId: $studentId');

      var appealId = FirebaseFirestore.instance.collection('appeal').doc().id;

      await FirebaseFirestore.instance.collection('appeal').doc(appealId).set({
        'eventId': widget.eventId,
        'appealId': appealId, // Include the appealId in the data
        'studentId': studentId,
        'userName': userName,
        'videoLink': userVideoLink,
        'department': userDepartment,
        'description': userDescription,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appeal submitted successfully!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error submitting appeal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting appeal. Please try again.'),
        ),
      );
    }
  }
}
