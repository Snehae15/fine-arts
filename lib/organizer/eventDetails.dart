import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventDetails extends StatefulWidget {
  final String resultId;

  const EventDetails(
      {Key? key, required this.resultId, required String eventId})
      : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  Map<String, dynamic>? resultDetails;
  Map<String, dynamic>? eventDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchResultDetails();
  }

  Future<void> fetchResultDetails() async {
    try {
      var resultDoc = await FirebaseFirestore.instance
          .collection('result')
          .doc(widget.resultId)
          .get();

      if (resultDoc.exists) {
        setState(() {
          resultDetails = resultDoc.data() as Map<String, dynamic>;
        });

        // Fetch associated event details
        String eventId = resultDetails?['eventId'] ?? '';
        if (eventId.isNotEmpty) {
          var eventDoc = await FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .get();

          if (eventDoc.exists) {
            setState(() {
              eventDetails = eventDoc.data() as Map<String, dynamic>;
              eventDetails?['name'] = eventDetails?['name'] ?? '';
              isLoading = false; // Data fetching completed
            });
          } else {
            print('Event not found for ID: $eventId');
            isLoading = false; // Data fetching completed with an error
          }
        } else {
          print('Event ID is empty in result details');
          isLoading = false; // Data fetching completed with an error
        }
      } else {
        print('Result not found for ID: ${widget.resultId}');
        isLoading = false; // Data fetching completed with an error
      }
    } catch (e) {
      print('Error fetching result details: $e');
      isLoading = false; // Data fetching completed with an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Event Detail',
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
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Center(
                      child: Text(
                        eventDetails?['name'] ?? 'Event Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 41.h),
                    if (eventDetails != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Date: ${eventDetails?['date'] ?? 'N/A'}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 32, 28, 28),
                                  fontSize: 18.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              Text(
                                'Stage No: ${eventDetails?['stage'] ?? 'N/A'}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 32, 28, 28),
                                  fontSize: 18.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              Text(
                                'Time: ${eventDetails?['time'] ?? 'N/A'}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 32, 28, 28),
                                  fontSize: 18.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 46.h),
                    ],
                    Text(
                      'Result',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    Container(
                      height: 350.h,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFB8B1B1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: resultDetails?['image_url'] != null
                            ? Image.network(
                                resultDetails?['image_url'],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Text('No result image available'),
                      ),
                    ),
                  ],
                )),
    );
  }
}
