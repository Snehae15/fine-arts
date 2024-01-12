import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/organizer/appealList.dart';
import 'package:flutter/material.dart';

class AppealsView extends StatefulWidget {
  const AppealsView({Key? key}) : super(key: key);

  @override
  State<AppealsView> createState() => _AppealsViewState();
}

class _AppealsViewState extends State<AppealsView> {
  List<Map<String, dynamic>> appealsData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('appeal').get();

    var data = await Future.wait(
      querySnapshot.docs.map((doc) async {
        var appealData = doc.data() as Map<String, dynamic>;
        var eventId = appealData['eventId'];
        var eventQuery = await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .get();

        var eventData = eventQuery.data() as Map<String, dynamic>;

        return {
          ...appealData,
          'eventId': eventId,
          'eventName': eventData['name'] ?? 'Event Name',
        };
      }),
    );

    setState(() {
      appealsData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 52.0,
            ),
            Text(
              'Appeal',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 0.0,
              ),
            ),
            SizedBox(
              height: 38.0,
            ),
            Column(
              children: appealsData.map((appeal) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        var selectedAppealId = appeal['appealId'];
                        var eventId = appeal['eventId'];
                        print('Selected Appeal ID: $selectedAppealId');
                        print('Event ID: $eventId');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppealList(
                              eventId: eventId,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 350.0,
                        height: 50.0,
                        padding: EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 28.0),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.0,
                              color: Color(0xFF558DBA),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/photo 1.png'),
                            SizedBox(
                              width: 28.0,
                            ),
                            Text(
                              appeal['eventName'] ?? 'Event Name',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
