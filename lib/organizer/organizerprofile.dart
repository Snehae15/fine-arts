import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/organizer/orgprofileedit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrganizerProfile extends StatefulWidget {
  const OrganizerProfile({Key? key});

  @override
  State<OrganizerProfile> createState() => _OrganizerProfileState();
}

class _OrganizerProfileState extends State<OrganizerProfile> {
  Map<String, dynamic>? organiserDetails;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    fetchOrganiserData();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> fetchOrganiserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String organizerDocId = prefs.getString('organizerDocId') ?? '';

      if (organizerDocId.isNotEmpty) {
        DocumentSnapshot organiserSnapshot = await FirebaseFirestore.instance
            .collection('organiser')
            .doc(organizerDocId)
            .get();

        if (_isMounted) {
          setState(() {
            organiserDetails =
                organiserSnapshot.data() as Map<String, dynamic>?;
          });
        }
      } else {
        if (_isMounted) {
          print('Organiser ID is empty');
        }
      }
    } catch (error) {
      if (_isMounted) {
        print('Error fetching organiser data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Organiser Profile',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrgEditProfile()),
              );
            },
          ),
        ],
      ),
      body: buildProfileContent(organiserDetails),
    );
  }

  Widget buildProfileContent(Map<String, dynamic>? organiserDetails) {
    if (organiserDetails == null) {
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
          organiserDetails['name'] ?? '',
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
          organiserDetails['idnumber'] ?? '',
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
          organiserDetails['email'] ?? '',
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
          organiserDetails['phonenumber'] ?? '',
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
