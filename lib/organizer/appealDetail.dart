import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/organizer/updateResult.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppealDetails extends StatefulWidget {
  const AppealDetails({
    Key? key,
    required this.eventId,
    required this.appealId,
  }) : super(key: key);

  final String eventId;
  final String appealId;

  @override
  _AppealDetailsState createState() => _AppealDetailsState();
}

class _AppealDetailsState extends State<AppealDetails> {
  Map<String, dynamic> eventDetails = {};
  Map<String, dynamic> appealDetails = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await fetchEventDetails();
      await fetchAppealDetails();
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchEventDetails() async {
    try {
      var eventQuery = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .get();

      if (eventQuery.exists) {
        setState(() {
          eventDetails = eventQuery.data() as Map<String, dynamic>;
        });
      } else {
        print('Event not found.');
      }
    } catch (error) {
      print('Error fetching event details: $error');
    }
  }

  Future<void> fetchAppealDetails() async {
    try {
      var appealQuery = await FirebaseFirestore.instance
          .collection('appeal')
          .doc(widget.appealId)
          .get();

      if (appealQuery.exists) {
        setState(() {
          appealDetails = appealQuery.data() as Map<String, dynamic>;
        });
      } else {
        print('Appeal not found.');
      }
    } catch (error) {
      print('Error fetching appeal details: $error');
    }
  }

  Future<void> updateStatus(String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('appeal')
          .doc(widget.appealId)
          .update({'status': newStatus});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated successfully'),
        ),
      );
    } catch (error) {
      print('Error updating status: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appeal Details',
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 33.h,
                  ),
                  CustomTextField2(
                    Title: 'Event Name',
                    text: eventDetails['name'] ?? '',
                  ),
                  SizedBox(
                    height: 23.h,
                  ),
                  CustomTextField2(
                    Title: 'Video Link',
                    text: appealDetails['videoLink'] ?? '',
                  ),
                  SizedBox(
                    height: 23.h,
                  ),
                  CustomTextField2(
                    Title: 'Description',
                    text: appealDetails['description'] ?? '',
                    lines: 7,
                  ),
                  SizedBox(
                    height: 168.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            updateStatus('Accepted');
                            if (appealDetails['status'] == 'Accepted') {
                              // Navigate to UpdateResult screen with eventId and appealId
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateResult(
                                    eventId: widget.eventId,
                                    appealId: widget.appealId,
                                  ),
                                ),
                              );
                            }
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
                        InkWell(
                          onTap: () {
                            updateStatus('Rejected');
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
                ],
              ),
            ),
    );
  }

  Padding CustomTextField2({String? Title, String? text, int? lines}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Title!),
            TextFormField(
              minLines: lines,
              maxLines: lines,
              readOnly: true,
              initialValue: text ?? '',
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: Color(0xFF1A1919),
              ),
            ),
          ],
        ),
      );
}
