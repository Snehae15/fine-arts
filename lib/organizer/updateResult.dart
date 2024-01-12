import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UpdateResult extends StatefulWidget {
  const UpdateResult({
    Key? key,
    required this.eventId,
    required this.appealId,
  }) : super(key: key);

  final String eventId;
  final String appealId;

  @override
  _UpdateResultState createState() => _UpdateResultState();
}

class _UpdateResultState extends State<UpdateResult> {
  Map<String, dynamic> eventDetails = {};
  Map<String, dynamic> appealDetails = {};
  bool isLoading = true;

  late TextEditingController resultController;
  late XFile? resultImage;

  @override
  void initState() {
    super.initState();
    resultController = TextEditingController();
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

  Future<void> pickResultImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      resultImage = pickedImage;
    });
  }

  Future<void> uploadResultImage() async {
    if (resultImage == null) {
      return;
    }

    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(
          'result_images/${DateTime.now().millisecondsSinceEpoch.toString()}');
      UploadTask uploadTask = storageReference.putFile(File(resultImage!.path));
      await uploadTask.whenComplete(() => null);
      String imageUrl = await storageReference.getDownloadURL();

      // Update Firestore collection with result details
      await FirebaseFirestore.instance
          .collection('result')
          .doc(widget.eventId)
          .set({
        'resultImage': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Result updated successfully'),
        ),
      );
    } catch (error) {
      print('Error uploading result image: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update result. Please try again.'),
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
                    hintText: eventDetails['name'] ?? '',
                  ),
                  SizedBox(
                    height: 23.h,
                  ),
                  CustomTextField2(
                    Title: 'Video Link',
                    hintText: appealDetails['videoLink'] ?? '',
                  ),
                  SizedBox(
                    height: 23.h,
                  ),
                  CustomTextField2(
                    Title: 'Description',
                    hintText: appealDetails['description'] ?? '',
                    lines: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: Text(
                      '  Result',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 167.h,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFB8B1B1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: InkWell(
                        onTap: pickResultImage,
                        child: resultImage == null
                            ? Center(
                                child: IconButton(
                                  onPressed: pickResultImage,
                                  icon: Image.asset('assets/photo 3.png'),
                                ),
                              )
                            : Image.file(
                                File(resultImage!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  CustomTextField2(
                    Title: 'Result Text',
                    hintText: 'Enter result details...',
                    controller: resultController,
                    lines: 3,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
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
                      onPressed: uploadResultImage,
                      child: Text(
                        'Submit',
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
                ],
              ),
            ),
    );
  }

  Padding CustomTextField2({
    String? Title,
    String? hintText,
    int? lines,
    TextEditingController? controller,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Title!),
            TextFormField(
              minLines: lines,
              maxLines: lines,
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Empty field';
                }
              },
              decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                hintStyle: TextStyle(
                  color: Color(0xFF1A1919),
                  fontSize: 15.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      );
}
