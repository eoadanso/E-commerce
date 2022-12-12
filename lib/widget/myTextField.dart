import 'package:flutter/material.dart';

Widget myTextField(hintText, keyboardType, controller){
  return TextField(
    keyboardType: keyboardType,
    controller: controller,
    decoration: InputDecoration(hintText: hintText),
  );
}