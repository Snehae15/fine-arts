import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StdDetails extends StatefulWidget {
  final String studentId;

  const StdDetails({Key? key, required this.studentId}) : super(key: key);

  @override
  State<StdDetails> createState() => _StdDetailsState();
}

class _StdDetailsState extends State<StdDetails> {
  late Map<String, dynamic> studentData;

  @override
  void initState() {
    super.initState();
    fetchStudentDetails();
  }

  Future<void> fetchStudentDetails() async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.studentId)
          .get();

      setState(() {
        studentData = snapshot.data() as Map<String, dynamic>;
      });
    } catch (e) {
      print('Error fetching student details: $e');
    }
  }

  Future<void> updateStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.studentId)
          .update({'status': status});

      fetchStudentDetails();
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          // automaticallyImplyLeading: false,
          title: Text(
            'Students Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          )),
      body: Column(children: [
        SizedBox(
          height: 75,
        ),
        Center(child: Image.asset('assets/user2.png')),
        SizedBox(
          height: 18.h,
        ),
        Text(
          '${studentData['name'] ?? ""}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        SizedBox(
          height: 41.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Id Number',
                  style: TextStyle(
                    color: Color(0xFF1A1919),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  'Department',
                  style: TextStyle(
                    color: Color(0xFF1A1919),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  'Phone Number',
                  style: TextStyle(
                    color: Color(0xFF1A1919),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Email',
                  style: TextStyle(
                    color: Color(0xFF1A1919),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Status',
                  style: TextStyle(
                    color: Color(0xFF1A1919),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${studentData['idNumber'] ?? ""}',
                  style: TextStyle(
                    color: Color(0xFFB8B1B1),
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  '${studentData['department'] ?? ""}',
                  style: TextStyle(
                    color: Color(0xFFB8B1B1),
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  '${studentData['phoneNumber'] ?? ""}',
                  style: TextStyle(
                    color: Color(0xFFB8B1B1),
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  '${studentData['email'] ?? ""}',
                  style: TextStyle(
                    color: Color(0xFFB8B1B1),
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  '${studentData['status'] ?? ""}',
                  style: TextStyle(
                    color: Color(0xFFB8B1B1),
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            ),
          ],
        ),
        Spacer(flex: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
    GestureDetector(
      onTap: () {
        updateStatus('Accepted'); // Function to update status to 'Accepted'
      },
      child: Container(
        width: 165.w,
        height: 50.h,
        decoration: ShapeDecoration(
          color: Color(0xFF0C5600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Center(
          child: Text(
            'Accept',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
        ),
      ),
    ),
    GestureDetector(
      onTap: () {
        updateStatus('Rejected'); // Function to update status to 'Rejected'
      },
      child: Container(
        width: 165.w,
        height: 50.h,
        decoration: ShapeDecoration(
          color: Color(0xFFAD290C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Center(
          child: Text(
            'Reject',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
        ),
      ),
    ),
  ],
),
        ),
        Spacer(),
      ]),
    );
  }
}
