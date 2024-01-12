import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/student/eventapply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Eventdetails extends StatefulWidget {
  final String documentId;
  const Eventdetails({Key? key, required this.documentId}) : super(key: key);

  @override
  State<Eventdetails> createState() => _EventdetailsState();
}

class _EventdetailsState extends State<Eventdetails> {
  Map<String, dynamic> eventData = {};
    bool isLoading = true;
     bool isApplied = false;

  @override
  void initState() {
    super.initState();
    fetchEventData();
    checkIfApplied();
  }

  Future<void> fetchEventData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('events').doc(widget.documentId).get();

      if (snapshot.exists) {
        setState(() {
          eventData = snapshot.data()!;
          isLoading=false;
        });
        print(eventData);
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
Future<void> checkIfApplied() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String studentId = prefs.getString('studentId') ?? '';

      if (studentId.isNotEmpty) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('EventRegistration')
                .where('eventId', isEqualTo: widget.documentId)
                .where('studentId', isEqualTo: studentId)
                .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            isApplied = true;
          });
        }
      } else {
        print('Student ID is empty');
      }
    } catch (e) {
      print('Error checking if applied: $e');
    }
  }

 Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await fetchEventData();
  }

  Future<void> registerForEvent() async {
    try {
      // Get studentId from shared preferences
      // Replace 'studentId' with your actual key for studentId in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String studentId = prefs.getString('studentId') ?? '';

      // Check if studentId exists
      if (studentId.isNotEmpty) {
        // Add a document to EventRegistration collection with required details
        await FirebaseFirestore.instance.collection('EventRegistration').add({
          'eventId': widget.documentId,
          'studentId': studentId,
          'date': DateTime.now(),
          'status': 'applied',
        });

        // Show a success message or perform any necessary actions after registration
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully applied for the event.'),
            duration: Duration(seconds: 2),
          ),
        );
         setState(() {
          isApplied = true;
        });

        // Refresh the page after applying
        refreshData();
      } else {
        print('Student ID is empty');
        // Handle the case when studentId is empty in shared preferences
      }
    } catch (e) {
      print('Error registering for event: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Event Detail ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          )),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            ):Column(children: [
        SizedBox(
          height: 75,
        ),
        Center(child: Image.asset('assets/user2.png')),
        SizedBox(
          height: 18.h,
        ),
        Text(
          eventData['name'] ?? '',
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
                  'Date',
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
                  'Stage No',
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
                  'Time',
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
                // Text(
                //   'Location',
                //   style: TextStyle(
                //     color: Color(0xFF1A1919),
                //     fontSize: 15.sp,
                //     fontFamily: 'Poppins',
                //     fontWeight: FontWeight.w400,
                //     height: 0,
                //   ),
                // )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventData['date'] ?? '',
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
                  eventData['stage'] ?? '',
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
                  eventData['time'] ?? '',
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
                // Text(
                //   'Ground',
                //   style: TextStyle(
                //     color: Color(0xFFB8B1B1),
                //     fontSize: 13.sp,
                //     fontFamily: 'Poppins',
                //     fontWeight: FontWeight.w400,
                //     height: 0,
                //   ),
                // )
              ],
            ),
          ],
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r))),
                  minimumSize: MaterialStatePropertyAll(Size(350.w, 50.h)),
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF204563))),
              onPressed:isApplied ? null : () {
                      registerForEvent();
                    },
              child: Text(
                isApplied ? 'Applied' : 'Apply',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              )),
        ),
      ]),
    );
  }
}
