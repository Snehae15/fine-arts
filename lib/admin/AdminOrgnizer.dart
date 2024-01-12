import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/admin/admminAssign2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminOrg extends StatefulWidget {
  final String documentId;

  const AdminOrg({Key? key, required this.documentId});

  @override
  State<AdminOrg> createState() => _AdminOrgState();
}

class _AdminOrgState extends State<AdminOrg> {
  String? name = '';
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
        name = documentSnapshot.get('name');
        idNumber = documentSnapshot.get('idnumber');
        phoneNumber = documentSnapshot.get('phonenumber');
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
              name ?? 'Name',
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
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 23).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assign',
                  style: TextStyle(
                    color: Color(0xFF1A1919),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                Container(
                  width: 350.w,
                  height: 143.h,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.w, color: Color(0xFFB8B1B1)),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assigned Events',
                        style: TextStyle(
                          color: Color(0xFF1A1919),
                          fontSize: 13.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('events')
                              .where('organiserId',
                                  isEqualTo: widget.documentId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('No events available'));
                            }

                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var eventData = snapshot.data!.docs[index];
                                String eventName = eventData['name'] ?? '';

                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: Text(
                                    '- $eventName',
                                    style: TextStyle(
                                      color: Color(0xFF1A1919),
                                      fontSize: 13.sp,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                )),
                minimumSize: MaterialStatePropertyAll(Size(350.w, 50.h)),
                backgroundColor: MaterialStatePropertyAll(Color(0xFF204563)),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AssignAdmin2(documentId: widget.documentId);
                    },
                  ),
                );
              },
              child: Text(
                'Assign',
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
}
