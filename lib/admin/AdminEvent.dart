import 'package:fine_arts/admin/adminAddEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEvent extends StatefulWidget {
  const AdminEvent({Key? key});

  @override
  State<AdminEvent> createState() => _AdminEventState();
}

class _AdminEventState extends State<AdminEvent> {
  late Stream<QuerySnapshot> _eventsStream;

  @override
  void initState() {
    super.initState();
    _eventsStream = FirebaseFirestore.instance.collection('events').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 68).h,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEventAdmin(),
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFFFDBE40),
          shape: CircleBorder(),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Event',
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
        stream: _eventsStream,
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

          final events = snapshot.data!.docs;

          return ListView.separated(
            itemCount: events.length,
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final event = events[index].data() as Map<String, dynamic>;

              return customContainer(
                eventName: event['name'] ?? 'Event Name',
                date: event['date'] ?? 'Date',
                time: event['time'] ?? 'Time',
                stage: event['stage'] ?? '0',
                onDelete: () {
                  _deleteEvent(events[index].reference);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _deleteEvent(DocumentReference eventRef) {
    eventRef.delete().then((value) {
      // Deletion successful
      print('Event deleted successfully');
    }).catchError((error) {
      // Error occurred while deleting
      print('Failed to delete event: $error');
    });
  }

  Container customContainer({
    required String eventName,
    required String date,
    required String time,
    required String stage,
    required VoidCallback onDelete,
  }) {
    return Container(
      width: 350.w,
      height: 130.h,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20).r,
      decoration: ShapeDecoration(
        color: Color(0xFF558DBA),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: Color(0xFF558DBA)),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                eventName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.white,
                onPressed: onDelete,
              ),
            ],
          ),
          Text(
            'Date   : $date',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          Text(
            'Time   : $time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 0.h,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stage : $stage',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
