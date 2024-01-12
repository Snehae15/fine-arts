import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssignAdmin2 extends StatelessWidget {
  final String documentId;

  const AssignAdmin2({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Assign',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20).w,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var eventData = snapshot.data!.docs[index];
                String name = eventData['name'] ?? '';

                return GestureDetector(
                  onTap: () {
                    String eventId = eventData.id;
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventId)
                        .update({
                      'organiserId': documentId,
                    }).then((_) {
                      print('Organiser ID added to event document');
                      // Navigate back to the previous page
                      Navigator.pop(context);
                    }).catchError((error) {
                      print('Error adding organiser ID: $error');
                    });
                  },
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 15,
                            ).r,
                            width: 293.w,
                            height: 51.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFF558DBA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
