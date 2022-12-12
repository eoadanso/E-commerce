import 'package:e_commerce/const/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController ? nameController;
  TextEditingController ? phoneController;
  TextEditingController ? ageController;


  setDataToTextField(data){
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.h, top: 20),
            child: TextFormField(
              controller: nameController = TextEditingController(text: data["name"]),
              decoration: const InputDecoration(
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.grey),
                )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right:  20.h, top: 30.h),
            child: TextFormField(
              controller: phoneController = TextEditingController(text: data["phone"]),
              decoration: const InputDecoration(
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey),
                  )
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(left: 20.w, right: 20.h, top: 30.h),
            child: TextFormField(
              controller: ageController = TextEditingController(text: data["age"]),
              decoration: const InputDecoration(
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey),
                  )
              ),
            ),
          ),
          const Divider(),
          SizedBox(
            height: 60.h,
            width: 1.sw,
            child: ElevatedButton(
              onPressed: updateData,
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: AppColor.deepBlue
              ), child: Text("Update Details",
            style: TextStyle(fontSize: 18.sp, color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  Future<void>updateData(){
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("users-form-data");
    return collectionReference.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": nameController!.text,
      "phone": phoneController!.text,
      "age": ageController!.text,
    }).then((value) => print("Successfully Updated"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users-form-data")
              .doc(FirebaseAuth.instance.currentUser!.email).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var data = snapshot.data;
            if(data == null){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return setDataToTextField(data);
          },
        ),
      ),
    );
  }
}
