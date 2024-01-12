import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/organizer/addresult.dart';
import 'package:fine_arts/organizer/eventDetails.dart';
import 'package:fine_arts/organizer/participentList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgEvent extends StatefulWidget {
  const OrgEvent({Key? key});

  @override
  State<OrgEvent> createState() => _OrgEventState();
}

class _OrgEventState extends State<OrgEvent> with TickerProviderStateMixin {
  List<Map<String, dynamic>> eventsData = [];
  List<Map<String, dynamic>> resultsData = [];
  bool isLoadingEvents = true;
  bool isLoadingResults = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchResults();
  }

  Future<void> fetchResults() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String organizerId = prefs.getString('organizerDocId') ?? '';

      if (organizerId.isNotEmpty) {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('result')
            .where('org_id', isEqualTo: organizerId)
            .get();

        var resultData = querySnapshot.docs;

        if (resultData.isNotEmpty) {
          List<Map<String, dynamic>> updatedResultsData = [];

          for (var resultDoc in resultData) {
            var result = resultDoc.data() as Map<String, dynamic>;
            String eventId = result['eventId'] ?? '';

            // Fetch event details based on eventID
            if (eventId.isNotEmpty) {
              var eventDetails = await FirebaseFirestore.instance
                  .collection('events')
                  .doc(eventId)
                  .get();

              if (eventDetails.exists) {
                var eventData = eventDetails.data() as Map<String, dynamic>;
                result['name'] = eventData['name'];
                updatedResultsData.add(result);
              }
            }
          }

          setState(() {
            resultsData = updatedResultsData;
            isLoadingResults = false; // Data fetching completed
          });
        } else {
          print('No results found for organizer: $organizerId');
          isLoadingResults = false; // Data fetching completed with no results
        }
      } else {
        print('Organizer ID is empty');
        isLoadingResults = false; // Data fetching completed with an error
      }
    } catch (e) {
      print('Error fetching results: $e');
      isLoadingResults = false; // Data fetching completed with an error
    }
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String organizerId = prefs.getString('organizerDocId') ?? '';

      if (organizerId.isNotEmpty) {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('events')
            .where('organiserId', isEqualTo: organizerId)
            .get();

        var eventData = querySnapshot.docs;

        if (eventData.isNotEmpty) {
          setState(() {
            eventsData = eventData.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              data['docId'] = doc.id;
              return data;
            }).toList();
          });
        } else {
          print('No events found for organizer: $organizerId');
        }
      } else {
        print('Organizer ID is empty');
      }

      setState(() {
        isLoadingEvents = false; // Data fetching completed
      });
    } catch (e) {
      print('Error fetching events: $e');
      isLoadingEvents = false; // Data fetching completed with an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 88).h,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddResult(),
                ),
              );
            },
            child: Icon(
              CupertinoIcons.plus,
              color: Colors.white,
            ),
            backgroundColor: Color(0xFFFDBE40),
            shape: CircleBorder(),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              CustomTabBar(),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    // "Event" tab
                    isLoadingEvents
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: eventsData.map((event) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    String documentId = event['docId'] ?? '';

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ParticipentList(
                                            documentId: documentId),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 350.w,
                                    height: 50.h,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF558DBA),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1.w,
                                          color: Color(0xFF558DBA),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        event['name'] ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                    // "Result" tab
                    isLoadingResults
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: resultsData.map((result) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    String eventId = result['eventId'] ?? '';

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventDetails(
                                          eventId: eventId,
                                          resultId: result['resultId'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 350.w,
                                    height: 50.h,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF558DBA),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1.w,
                                          color: Color(0xFF558DBA),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        result['name'] ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding CustomTabBar() {
    return Padding(
      padding: const EdgeInsets.all(20).r,
      child: Container(
        height: 37.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: Color(0x702276BB),
        ),
        child: TabBar(
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: Color(0xFFFDBE40),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(
              child: Center(
                child: Text(
                  'Event',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ),
            ),
            Tab(
              child: Text(
                'Result',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
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
