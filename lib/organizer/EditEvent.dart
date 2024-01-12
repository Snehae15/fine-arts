import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_arts/organizer/organizerAssign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditEvent extends StatefulWidget {
  final String documentId;

  const EditEvent({Key? key, required this.documentId}) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final formKey = GlobalKey<FormState>();
  var name = TextEditingController();
  var date = TextEditingController();
  var stage = TextEditingController();
  var time = TextEditingController();
  var location = TextEditingController();
  Map<String, dynamic> eventData = {};

  Future<void> fetchEventData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('events')
          .doc(widget.documentId)
          .get();

      if (snapshot.exists) {
        eventData = snapshot.data()!;
        setState(() {
          name.text = eventData['name'] ?? '';
          date.text = eventData['date'] ?? '';
          stage.text = eventData['stage'] ?? '';
          time.text = eventData['time'] ?? '';
          location.text = eventData['location'] ?? '';
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> updateEventData() async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.documentId)
          .update({
        'name': name.text,
        'date': date.text,
        'stage': stage.text,
        'time': time.text,
        'location': location.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event details updated')),
      );
    } catch (e) {
      print('Error updating data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update event details')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Event',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 30),
              CustomTextField2(
                controller: name,
                title: 'Event',
                hintText: eventData['name'],
              ),
              SizedBox(height: 22.h),
              CustomTextField2(
                controller: date,
                title: 'Date',
                hintText: eventData['date'],
              ),
              SizedBox(height: 22.h),
              CustomTextField2(
                controller: stage,
                title: 'Stage No',
                hintText: eventData['stage'],
              ),
              SizedBox(height: 22.h),
              CustomTextField2(
                controller: time,
                title: 'Time',
                hintText: eventData['time'],
              ),
              SizedBox(height: 22.h),
              // CustomTextField2(
              //   controller: location,
              //   title: 'Location',
              //   hintText: eventData['location'],
              // ),
              Spacer(),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r))),
                      minimumSize: MaterialStatePropertyAll(Size(350.w, 50.h)),
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFF204563))),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      updateEventData().then((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrgAssign()), // Replace NextScreen with your desired screen
                        );
                      });
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  )),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Padding CustomTextField2({String? title, String? hintText, var controller}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title!),
            TextFormField(
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Empty field';
                }
              },
              decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.symmetric(horizontal: 20).r,
                hintStyle: TextStyle(
                  color: Color(0xFF1A1919),
                  fontSize: 15.sp,
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
