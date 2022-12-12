import 'dart:async';

import 'package:e_commerce/const/appcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(const Duration(seconds: 3),
            ()=> Navigator.push(
                context, CupertinoPageRoute(
                builder: (_) => const LoginScreen())));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("E-Commerce",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 44.sp,
                color: Colors.white
              ),
              ),
              SizedBox(height: 40.h,),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
