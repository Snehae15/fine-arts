import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddEventAdmin extends StatefulWidget {
  const AddEventAdmin({Key? key}) : super(key: key);

  @override
  State<AddEventAdmin> createState() => _AddEventAdminState();
}

class _AddEventAdminState extends State<AddEventAdmin> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController stageController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
      setDefaultValues();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = formatDate(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        timeController.text = pickedTime.format(context);
      });
    }
  }

  void setDefaultValues() {
    dateController.text = formatDate(selectedDate);
    timeController.text = selectedTime.format(context);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Event',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                title: 'Name',
                hintText: 'Enter event name',
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: dateController,
                title: 'Date',
                hintText: 'Select date',
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: stageController,
                title: 'Stage No',
                hintText: 'Enter stage number',
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: timeController,
                title: 'Time',
                hintText: 'Select time',
                onTap: () => _selectTime(context),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  minimumSize: MaterialStateProperty.all(Size(350, 50)),
                  backgroundColor: MaterialStateProperty.all(Color(0xFF204563)),
                ),
                onPressed: () async {
                  String name = nameController.text;
                  String date = dateController.text;
                  String stage = stageController.text;
                  String time = timeController.text;

                  // Access Firestore instance and add data to a collection
                  CollectionReference events =
                      FirebaseFirestore.instance.collection('events');

                  // Add the event data to Firestore with auto-generated eventId
                  await events.add({
                    'name': name,
                    'date': date,
                    'stage': stage,
                    'time': time,
                  }).then((DocumentReference document) async {
                    // Get the auto-generated eventId
                    String eventId = document.id;
                    print('Event added with ID: $eventId');

                    // Update the document with the generated eventId
                    await document.update({'eventId': eventId});

                    Fluttertoast.showToast(
                      msg: 'Event added successfully!',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );

                    // Navigate to the previous page
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  final VoidCallback? onTap;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.title,
    required this.hintText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        TextField(
          controller: controller,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintStyle: TextStyle(
              color: Color(0xFF1A1919),
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
