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
    required this.eventName,
    required this.videoLink,
    required this.description,
  }) : super(key: key);

  final String eventId;
  final String appealId;
  final String eventName;
  final String videoLink;
  final String description;

  @override
  State<UpdateResult> createState() => _UpdateResultState();
}

class _UpdateResultState extends State<UpdateResult> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController videoLinkController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Result',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 33.h),
          CustomTextField2(
            Title: 'Event Name',
            hintText: widget.eventName,
            controller: eventNameController,
          ),
          SizedBox(height: 23.h),
          CustomTextField2(
            Title: 'Video Link',
            hintText: widget.videoLink,
            controller: videoLinkController,
          ),
          SizedBox(height: 23.h),
          CustomTextField2(
            Title: 'Description',
            hintText: widget.description,
            lines: 7,
            controller: descriptionController,
          ),
          SizedBox(height: 23.h),
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
            child: GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: Container(
                height: 167.h,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFB8B1B1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Center(
                  child: _image == null
                      ? IconButton(
                          onPressed: () {
                            _pickImage();
                          },
                          icon: Icon(Icons.add_photo_alternate),
                        )
                      : Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                minimumSize: MaterialStateProperty.all(Size(350, 50)),
                backgroundColor: MaterialStateProperty.all(Color(0xFF204563)),
              ),
              onPressed: () {
                _submitDetails();
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> _submitDetails() async {
    String eventName = eventNameController.text;
    String videoLink = videoLinkController.text;
    String description = descriptionController.text;

    CollectionReference resultsCollection =
        FirebaseFirestore.instance.collection('result');

    String? imageUrl = _image != null ? await _uploadImage() : null;

    QuerySnapshot querySnapshot = await resultsCollection
        .where('eventId', isEqualTo: widget.eventId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      // Check if a new image is selected, if not, use the existing image URL
      if (_image == null) {
        imageUrl = documentSnapshot['image_url'];
      } else {
        // Delete the previous image from Firebase Storage
        if (documentSnapshot['image_url'] != null &&
            documentSnapshot['image_url'] != '') {
          await FirebaseStorage.instance
              .refFromURL(documentSnapshot['image_url'])
              .delete();
        }
      }

      await documentSnapshot.reference.update({
        'eventName': eventName,
        'videoLink': videoLink,
        'description': description,
        'image_url': imageUrl,
      });

      print('Event Name: $eventName');
      print('Video Link: $videoLink');
      print('Description: $description');
      print('Image URL: $imageUrl');
      print('Details updated successfully!');
    } else {
      await resultsCollection.add({
        'eventId': widget.eventId,
        'appealId': widget.appealId,
        'eventName': eventName,
        'videoLink': videoLink,
        'description': description,
        'image_url': imageUrl,
      });

      print('Event Name: $eventName');
      print('Video Link: $videoLink');
      print('Description: $description');
      print('Image URL: $imageUrl');
      print('Details submitted successfully!');
    }

    Navigator.pop(context);
  }

  Future<String> _uploadImage() async {
    try {
      File imageFile = File(_image!.path);

      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('result/${DateTime.now().millisecondsSinceEpoch.toString()}');
      await storageReference.putFile(imageFile);

      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Padding CustomTextField2(
      {String? Title, String? hintText, var controller, int? lines}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Title!),
          TextFormField(
            minLines: lines,
            maxLines: lines,
            controller: controller,
            readOnly: true,
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
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
