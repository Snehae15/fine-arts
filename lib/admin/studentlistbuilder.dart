import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/admin/studentdetails.dart'; // Assuming this is the screen for displaying student details

class StdlistBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Students List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> studentData = documents[index].data() as Map<String, dynamic>;
              final String studentId = documents[index].id; // Get the document ID
              final String status = studentData['status'] ?? ''; // Get the status

              Color statusColor = Colors.transparent; // Default transparent color
              if (status.toLowerCase() == 'accepted') {
                statusColor = Colors.green; // Green color for Accepted status
              } else if (status.toLowerCase() == 'rejected') {
                statusColor = Colors.red; // Red color for Rejected status
              } else if(status.toLowerCase()=='pending'){
                statusColor=const Color.fromARGB(255, 22, 26, 29);
              }

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return StdDetails(studentId: studentId); // Pass student ID to StdDetails screen
                      },
                    ),
                  );
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      height: 60.h,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFF191717)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: Row(
                          children: [
                            Image.asset('assets/user2.1.png'),
                            SizedBox(
                              width: 20.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  studentData['name'] ?? '', // Display name
                                  style: TextStyle(
                                    color: Color(0xFF1A1919),
                                    fontSize: 15.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  studentData['idNumber'] ?? '', // Display ID number
                                  style: TextStyle(
                                    color: Color(0xFFB8B1B1),
                                    fontSize: 13.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 80.w,
                              height: double.infinity,
                              decoration: BoxDecoration(
                  color: statusColor, // Apply color based on status
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                ),
                               // Apply color based on status
                              alignment: Alignment.center,
                              child: Text(
                                status, // Display status text
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
