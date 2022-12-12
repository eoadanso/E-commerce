import 'package:e_commerce/const/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/customButton.dart';
import '../widget/myTextField.dart';
import 'bottom_nav_controller.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
    }
  }

  sendUserDataToDB()async{

    final FirebaseAuth auth = FirebaseAuth.instance;
    var  currentUser = auth.currentUser;

    CollectionReference collectionReference = FirebaseFirestore.instance.collection("users-form-data");
    return collectionReference.doc(currentUser!.email).set({
      "name":nameController.text,
      "phone":phoneController.text,
      "dob":dobController.text,
      "gender":genderController.text,
      "age":ageController.text,
    }).then((value) => Navigator.push(context, MaterialPageRoute(builder: (_)=> const BottomNavigatorController()))
    ).catchError((error)=>print("Something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Submit the form to continue.",
                  style:
                  TextStyle(fontSize: 22.sp, color: AppColor.deepBlue, fontWeight: FontWeight.bold),
                ),
                Text(
                  "We will keep your details confidential",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFFBBBBBB),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                myTextField("Enter your name",TextInputType.text, nameController),
                SizedBox(
                  height: 15.h,
                ),
                myTextField("Enter your phone number",TextInputType.number, phoneController),
                SizedBox(
                  height: 15.h,
                ),
                TextField(
                  controller: dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Date of birth",
                    suffixIcon: IconButton(
                      onPressed: () => _selectDateFromPicker(context),
                      icon: const Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextField(
                  controller: genderController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Select your gender",
                    suffixIcon: DropdownButton<String>(
                      items: gender.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                          onTap: () {
                            setState(() {
                              genderController.text = value;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                myTextField("Enter your age",TextInputType.number, ageController),
                SizedBox(
                  height: 80.h,
                ),
                // elevated button
                customButton("Continue",()=>sendUserDataToDB()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
