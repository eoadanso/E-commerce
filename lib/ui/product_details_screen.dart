import 'package:e_commerce/const/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailsScreen extends StatefulWidget {
  var product;
  ProductDetailsScreen({Key? key,required this.product}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  Future addToCart() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var currentUser = firebaseAuth.currentUser;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("users-cart-items");
    return collectionReference.doc(currentUser!.email).collection("items").doc().set({
      "name": widget.product["product-name"],
      "price": widget.product["product-price"],
      "images": widget.product["product-img"],
    }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to cart successfully",
          style: TextStyle(fontSize: 20),),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          margin: EdgeInsets.all(50),
        )));
  }
  
  Future addToFavorite() async{
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var currentUser = firebaseAuth.currentUser;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("users-favorite-items");
    return collectionReference.doc(currentUser!.email).collection("items").doc().set({
          "name": widget.product["product-name"],
          "price": widget.product["product-price"],
          "images": widget.product["product-img"],

    }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to favorite successfully",
          style: TextStyle(fontSize: 20),),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          margin: EdgeInsets.all(50),
        )));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColor.deepBlue,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_outlined),
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users-favorite-items").doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items").where("name", isEqualTo: widget.product["product-name"]).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.data == null){
                return const Text("");
              }
              return Padding(
                  padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        backgroundColor: AppColor.deepBlue,
                        child: IconButton(
                            onPressed: () => snapshot.data.docs.length == 0 ? addToFavorite() : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Already added to favorite",
                                  style: TextStyle(fontSize: 20),),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  margin: EdgeInsets.all(50),
                                )),
                            icon: snapshot.data.docs.length == 0 ?
                            const Icon(Icons.favorite_outline,color:  Colors.white,):
                            const Icon(Icons.favorite, color: Colors.red,)
                        ),
                      ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(aspectRatio: 2.5,
                child: CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                  ), items: widget.product["product-img"]
                    .map<Widget>((items) => Padding(padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(items),
                          fit: BoxFit.fitWidth,
                        )
                    ),
                  ),
                ),
                ).toList(),
                ),
              ),
              Text("Name: ${widget.product["product-name"]}",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Text("Description: ${widget.product["product-description"]}",
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h,),
              Text("Price: ${widget.product["product-price"]}",
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
              const Divider(),
              SizedBox(
                height: 60.h,
                width: 1.sw,
                child: ElevatedButton(onPressed: () => addToCart(),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: AppColor.deepBlue
                  ),
                 child: Text("Add to Cart",
                   style: TextStyle(fontSize: 18.sp, color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
