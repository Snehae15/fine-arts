import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/organizer/appealDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppealList extends StatefulWidget {
  const AppealList({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  State<AppealList> createState() => _AppealListState();
}

class _AppealListState extends State<AppealList> {
  List<Map<String, dynamic>> appealsData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appeal List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20).w,
        child: Column(
          children: [
            SizedBox(
              height: 18.h,
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchAppealsData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No appeals found.');
                } else {
                  return Column(
                    children: [
                      customContainer(
                        text: '',
                        appealData: snapshot.data!,
                        context: context,
                      ),
                      SizedBox(height: 15.h),
                      customContainer(
                        text: 'Rejected',
                        color: Colors.red,
                        appealData: snapshot.data!,
                        context: context,
                      ),
                      SizedBox(height: 15.h),
                      customContainer(
                        text: 'Accepted',
                        color: Colors.green,
                        appealData: snapshot.data!,
                        context: context,
                      ),
                      SizedBox(height: 15.h),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchAppealsData() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('appeal')
        .where('eventId', isEqualTo: widget.eventId)
        .get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['docId'] = doc.id; // Add docId to the appeal data
      return data;
    }).toList();
  }

  InkWell customContainer({
    String? text,
    Color? color,
    required List<Map<String, dynamic>> appealData,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppealDetails(
              eventId: widget.eventId,
              appealId: appealData[0]['docId'],
            ),
          ),
        );
      },
      child: Container(
        width: 350.w,
        height: 60.h,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.w, color: Color(0xFF191717)),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchStudentDetails(appealData[0]['studentId']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('Student details not found.');
              } else {
                var studentDetails = snapshot.data!;
                Color statusColor =
                    Colors.orange; // Default color for pending status

                // Check the status and update the color accordingly
                String status = appealData[0]['status'] ?? 'Pending';
                if (status == 'Accepted') {
                  statusColor = Colors.green;
                } else if (status == 'Rejected') {
                  statusColor = Colors.red;
                }

                return Row(
                  children: [
                    Image.asset('assets/user2.1.png'),
                    SizedBox(width: 20.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          studentDetails['name'] ?? 'Name',
                          style: TextStyle(
                            color: Color(0xFF1A1919),
                            fontSize: 15.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        Text(
                          studentDetails['idNumber'] ?? 'ID Number',
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
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 13.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchStudentDetails(String studentId) async {
    var studentQuery = await FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .get();

    return studentQuery.data() as Map<String, dynamic>;
  }
}
