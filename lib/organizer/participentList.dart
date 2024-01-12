import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParticipentList extends StatefulWidget {
  final String documentId;

  const ParticipentList({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ParticipentList> createState() => _ParticipentListState();
}

class _ParticipentListState extends State<ParticipentList> {
  List<Map<String, dynamic>> participants = [];

  @override
  void initState() {
    super.initState();
    fetchParticipants();
  }

  Future<void> fetchParticipants() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('EventRegistration')
              .where('eventId', isEqualTo: widget.documentId)
              .get();

      List<Map<String, dynamic>> tempParticipants = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
          in querySnapshot.docs) {
        String studentId = docSnapshot.get('studentId');
        DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
            await FirebaseFirestore.instance
                .collection('students')
                .doc(studentId)
                .get();

        if (studentSnapshot.exists) {
          Map<String, dynamic> studentData = studentSnapshot.data()!;
          tempParticipants.add(studentData);
        }
      }

      setState(() {
        participants = tempParticipants;
      });
    } catch (e) {
      print('Error fetching participants: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Participants List',
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
        padding: EdgeInsets.all(20.w),
        child: ListView.builder(
          itemCount: participants.length,
          itemBuilder: (BuildContext context, int index) {
            return customContainer(
              participants[index]['name'],
              participants[index]['idNumber'],
              participants[index]['phoneNumber'] ?? '',
              participants[index]['email'] ?? '',
              participants[index]['department'] ?? '',
            );
          },
        ),
      ),
    );
  }

  Container customContainer(
    String name,
    String idNumber,
    String phoneNumber,
    String email,
    String department,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xFF191717)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: $name',
            style: TextStyle(
              color: Color(0xFF1A1919),
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'ID Number: $idNumber',
            style: TextStyle(
              color: Color.fromARGB(255, 37, 124, 170),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'Department: $department',
            style: TextStyle(
              color: Color.fromARGB(255, 37, 124, 170),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Phone Number: $phoneNumber',
            style: TextStyle(
              color: Color.fromARGB(255, 37, 124, 170),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'Email: $email',
            style: TextStyle(
              color: Color.fromARGB(255, 37, 124, 170),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
