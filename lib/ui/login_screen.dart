import 'package:e_commerce/const/appcolor.dart';
import 'package:e_commerce/ui/bottom_nav_controller.dart';
import 'package:e_commerce/ui/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widget/customButton.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;


  signIn () async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      var authCredential = userCredential.user;
      print(authCredential!.uid);
      if(authCredential.uid.isNotEmpty){
        Navigator.push(context, CupertinoPageRoute(builder: (_) => BottomNavigatorController()));
      }else{
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    }on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found'){
        Fluttertoast.showToast(msg: "No user found for that email");
      }else if(e.code == 'wrong-password'){
        Fluttertoast.showToast(msg: "Wrong password provided for that user");
      }
    } catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 150.h,
              width: ScreenUtil().screenWidth,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.light,
                        color: Colors.transparent,
                      ),
                    ),
                    Text(
                      "Sign In",
                      style: TextStyle(fontSize: 22.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: ScreenUtil().screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
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
                          "Welcome",
                          style: TextStyle(
                              fontSize: 22.sp, color: AppColor.deepBlue),
                        ),
                        Text(
                          "Glad to see you back",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFBBBBBB),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 48.h,
                              width: 41.w,
                              decoration: BoxDecoration(
                                  color: AppColor.deepBlue,
                                  borderRadius: BorderRadius.circular(12.r)),
                              child: Center(
                                child: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                  size: 20.w,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: "something@gmail.com",
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF414041),
                                  ),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontSize: 15.sp,
                                    color: AppColor.deepBlue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 48.h,
                              width: 41.w,
                              decoration: BoxDecoration(
                                  color: AppColor.deepBlue,
                                  borderRadius: BorderRadius.circular(12.r)),
                              child: Center(
                                child: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                  size: 20.w,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: TextField(
                                controller: passwordController,
                                obscureText: obscureText,
                                decoration: InputDecoration(
                                  hintText: "password must be at least 6 character",
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF414041),
                                  ),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    fontSize: 15.sp,
                                    color: AppColor.deepBlue,
                                  ),
                                  suffixIcon: obscureText == true
                                      ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscureText = false;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        size: 20.w,
                                      ))
                                      : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscureText = true;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.visibility_off,
                                        size: 20.w,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 50.h,
                        ),
                        // elevated button
                        customButton("Sign In", (){
                          signIn();
                        },),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                          child: Wrap(
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFBBBBBB),
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  " Sign Up",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.deepBlue,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              const RegistrationScreen()));
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
