import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrgAccept extends StatefulWidget {
  final String documentId;

  const OrgAccept({Key? key, required this.documentId});

  @override
  State<OrgAccept> createState() => _OrgAcceptState();
}

class _OrgAcceptState extends State<OrgAccept> {
  Map<String, dynamic>? name;
  String? idNumber = '';
  String? phoneNumber = '';

  @override
  void initState() {
    super.initState();
    fetchOrganiserDetails();
  }

  Future<void> fetchOrganiserDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('organiser')
          .doc(widget.documentId)
          .get();

      setState(() {
        name = documentSnapshot.data() as Map<String, dynamic>?;
        idNumber = name?['idnumber'];
        phoneNumber = name?['phonenumber'];
      });
    } catch (e) {
      print('Error fetching organiser details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Organizer',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 45,
          ),
          Center(child: Image.asset('assets/user2.png')),
          SizedBox(
            height: 18.h,
          ),
          Center(
            child: Text(
              name?['name'] ?? 'Name',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          SizedBox(
            height: 77.h,
          ),
          CustomTextField2(
            Title: 'ID Number',
            hintText: idNumber ?? '',
          ),
          SizedBox(
            height: 43.h,
          ),
          CustomTextField2(
            Title: 'Phone Number',
            hintText: phoneNumber ?? '',
          ),
          SizedBox(
            height: 30.h,
          ),
          Center(
            child: Text(
              'Organizer Status: ${name?['status'] ?? ""}',
              style: TextStyle(
                color: Color.fromARGB(255, 26, 19, 19),
                fontSize: 13.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          Spacer(flex: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    updateStatus(
                        'Accepted'); // Function to update status to 'Accepted'
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
                    updateStatus(
                        'Rejected'); // Function to update status to 'Rejected'
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
        ],
      ),
    );
  }

  Padding CustomTextField2({String? Title, String? hintText, var controller}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Title!),
            TextFormField(
              readOnly: true,
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
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 13.sp,
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

  void updateStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('organiser')
          .doc(widget.documentId)
          .update({'status': status});

      setState(() {
        name?['status'] = status;
      });

      // You can add further logic if needed after updating the status
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}
