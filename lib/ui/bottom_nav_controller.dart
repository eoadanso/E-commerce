import 'package:e_commerce/const/appcolor.dart';
import 'package:e_commerce/ui/bottom_nav_pages/cart.dart';
import 'package:e_commerce/ui/bottom_nav_pages/home.dart';
import 'package:e_commerce/ui/bottom_nav_pages/profile.dart';
import 'package:flutter/material.dart';

import 'bottom_nav_pages/favorite.dart';

class BottomNavigatorController extends StatefulWidget {
  const BottomNavigatorController({Key? key}) : super(key: key);

  @override
  State<BottomNavigatorController> createState() => _BottomNavigatorControllerState();
}

class _BottomNavigatorControllerState extends State<BottomNavigatorController> {
  final pages = [
    const Home(),
    const Favorite(),
    const Cart(),
    const Profile(),
  ];

  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "E-Commerce",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25, fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: AppColor.deepBlue,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        selectedLabelStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold
        ),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: "Favorite"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart_outlined),
              label: "Cart"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile"
          ),
        ],
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: pages[currentIndex],
    );
  }
}
