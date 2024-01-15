import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgEditProfile extends StatefulWidget {
  const OrgEditProfile({Key? key}) : super(key: key);

  @override
  State<OrgEditProfile> createState() => _OrgEditProfileState();
}

class _OrgEditProfileState extends State<OrgEditProfile> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController idnumber = TextEditingController();
  final TextEditingController department = TextEditingController();

  final formKey = GlobalKey<FormState>();

  late String organizerDocId;

  @override
  void initState() {
    super.initState();
    fetchOrganiserData();
  }

  Future<void> fetchOrganiserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    organizerDocId = prefs.getString('organizerDocId') ?? '';

    try {
      DocumentSnapshot organiserSnapshot = await FirebaseFirestore.instance
          .collection('organiser')
          .doc(organizerDocId)
          .get();

      if (organiserSnapshot.exists) {
        Map<String, dynamic> organiserDetails =
            (organiserSnapshot.data() as Map<String, dynamic>?) ?? {};
        setState(() {
          name.text = organiserDetails['name'] ?? '';
          phonenumber.text = organiserDetails['phoneNumber'] ?? '';
          email.text = organiserDetails['email'] ?? '';
          idnumber.text = organiserDetails['idNumber'] ?? '';
          department.text = organiserDetails['department'] ?? '';
        });
      } else {
        print('Organiser data not found for organizerDocId: $organizerDocId');
      }
    } catch (error) {
      print('Error fetching Organiser data: $error');
    }
  }

  void _submitForm() async {
    if (formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('organiser')
            .doc(organizerDocId)
            .update({
          'name': name.text,
          'phonenumber': phonenumber.text,
          'email': email.text,
          'idnumber': idnumber.text,
          'department': department.text,
        });

        Navigator.pop(context); // Navigate back to the previous screen
      } catch (error) {
        print('Error updating organiser data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
                SizedBox(height: 47),
                CustomTextField2(
                  controller: name,
                  title: 'Name',
                ),
                SizedBox(height: 22),
                CustomTextField2(
                  controller: phonenumber,
                  title: 'Phone No',
                ),
                SizedBox(height: 22),
                CustomTextField2(
                  controller: email,
                  title: 'Email',
                ),
                SizedBox(height: 22),
                CustomTextField2(
                  controller: idnumber,
                  title: 'ID Number',
                ),
                SizedBox(height: 22),
                CustomTextField2(
                  controller: department,
                  title: 'Department',
                ),
                Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(350, 50),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xFF204563),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    'Save Changes',
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
      ),
    );
  }
}

class CustomTextField2 extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const CustomTextField2({
    required this.title,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Empty field';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter $title',
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              hintStyle: TextStyle(
                color: Color(0xFF1A1919),
                fontSize: 15,
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
