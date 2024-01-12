import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/student/applyappeal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Resultdetails extends StatefulWidget {
  final String documentId;

  const Resultdetails({Key? key, required this.documentId}) : super(key: key);

  @override
  State<Resultdetails> createState() => _ResultdetailsState();
}

class _ResultdetailsState extends State<Resultdetails> {
  Map<String, dynamic> eventData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  Future<void> fetchEventData() async {
    try {
      // Fetch event data
      DocumentSnapshot<Map<String, dynamic>> eventSnapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .doc(widget.documentId)
              .get();

      if (eventSnapshot.exists) {
        setState(() {
          eventData = eventSnapshot.data()!;
          isLoading = false;
        });

        // Fetch result data based on eventId
        QuerySnapshot<Map<String, dynamic>> resultQuerySnapshot =
            await FirebaseFirestore.instance
                .collection('result')
                .where('eventId', isEqualTo: widget.documentId)
                .get();

        if (resultQuerySnapshot.docs.isNotEmpty) {
          Map<String, dynamic> resultData =
              resultQuerySnapshot.docs.first.data();

          setState(() {
            eventData['resultDetails'] = resultData;
          });
        } else {
          // Handle case when there are no results for the event
          print('No results found for event: ${widget.documentId}');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      // Set loading to false once data is fetched (whether successful or not)
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Event Results ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18.h,
                  ),
                  Center(
                    child: Text(
                      eventData['name'] ?? 'Event Name not available',
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
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventData['date'] ?? 'Date not available',
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
                            eventData['stage'] ?? 'Stage not available',
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
                            eventData['time'] ?? 'Time not available',
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
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 46.h,
                  ),
                  Text(
                    '  Result',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2.8,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFFB8B1B1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: eventData['resultDetails']?['image_url'] != null
                          ? Image.network(
                              eventData['resultDetails']?['image_url'],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Text('No Result added'),
                            ),
                    ),
                  ),
                  Spacer(),
                  if (eventData['resultDetails']?['image_url'] != null)
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
                        // Pass required data to ApplyAppeal page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ApplyAppeal(
                                eventId: widget.documentId,
                                // userId: '',
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Appeal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
