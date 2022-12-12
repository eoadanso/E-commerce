import 'package:e_commerce/const/appcolor.dart';
import 'package:e_commerce/ui/product_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../search_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List <String> carouselImages = [];
  var dotPosition = 0;
  List product = [];
  var fireStoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot querySnapshot = await fireStoreInstance.collection("carousel-slider").get();
    setState(() {
      for(int i = 0; i < querySnapshot.docs.length; i++ ){
        carouselImages.add(
          querySnapshot.docs[i]["img-path"]);
          print(querySnapshot.docs[i]["img-path"]);
      }
    });
    return querySnapshot.docs;
  }
  
  fetchProducts() async {
    QuerySnapshot querySnapshot = await fireStoreInstance.collection("products").get();
    setState(() {
      for(int i = 0; i < querySnapshot.docs.length; i++){
        product.add({
          "product-name": querySnapshot.docs[i]["product-name"],
          "product-description": querySnapshot.docs[i]["product-description"],
          "product-price": querySnapshot.docs[i]["product-price"],
          "product-img": querySnapshot.docs[i]["product-img"],
        });
      }
    });
    return querySnapshot.docs;
  }

  @override
  void initState() {
    fetchCarouselImages();
    fetchProducts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  suffixIcon: const Icon(Icons.search_outlined),
                  hintText: "Search for products here",
                  hintStyle: TextStyle(fontSize: 15.sp),
                ),
                onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const SearchScreen())
              ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            AspectRatio(aspectRatio: 2.5,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (val, carouselPageChangedReason){
                  setState(() {
                    dotPosition = val;
                  });
                }
              ), items: carouselImages
                .map((items) => Padding(padding: const EdgeInsets.only(left: 10, right: 10),
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
            SizedBox(
              height: 10.h,
            ),
            DotsIndicator(
              dotsCount: carouselImages.isEmpty ? 1 : carouselImages.length,
              position: dotPosition.toDouble(),
              decorator: DotsDecorator(
                activeColor: AppColor.deepBlue,
                color: AppColor.deepBlue.withOpacity(0.5),
                spacing: const EdgeInsets.all(10),
                activeSize: const Size(8,8),
                size: const Size(6,6)
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                    itemCount: product.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      childAspectRatio: 1),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product[index],))),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.black12)
                        ),
                        elevation: 8,
                        child: Column(
                          children: [
                            AspectRatio(aspectRatio: 1.5,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Image.network(
                                  product[index]["product-img"][0],
                                ),
                              ),
                            ),
                            Text(product[index]["product-name"],
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            Text(product[index]["product-price"],
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
