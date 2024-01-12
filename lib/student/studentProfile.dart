import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/student/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  Map<String, dynamic>? studentDetails;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String studentId = prefs.getString('studentId') ?? '';

    if (studentId.isNotEmpty) {
      try {
        DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .get();

        if (studentSnapshot.exists) {
          setState(() {
            studentDetails = studentSnapshot.data() as Map<String, dynamic>;
          });
        } else {
          print('Student data not found for studentId: $studentId');
        }
      } catch (error) {
        print('Error fetching student data: $error');
      }
    } else {
      print('Student ID is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Student Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to EditProfile screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              );
            },
          ),
        ],
      ),
      body: buildProfileContent(studentDetails),
    );
  }

  Widget buildProfileContent(Map<String, dynamic>? studentDetails) {
    if (studentDetails == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 75,
        ),
        Center(child: Image.asset('assets/user2.png')),
        SizedBox(
          height: 18.h,
        ),
        Text(
          'Name',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          studentDetails['name'] ?? '',
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
        // Display other details similarly
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
          height: 10.h,
        ),
        Text(
          studentDetails['idNumber'] ?? '',
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
          height: 10.h,
        ),
        Text(
          studentDetails['email'] ?? '',
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
          'Phone number',
          style: TextStyle(
            color: Color(0xFF1A1919),
            fontSize: 15.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          studentDetails['phoneNumber'] ?? '',
          style: TextStyle(
            color: Color(0xFFB8B1B1),
            fontSize: 13.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        Spacer(flex: 2),
        Spacer(),
      ],
    );
  }
}
