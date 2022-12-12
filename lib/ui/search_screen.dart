import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("E-Commerce",
        style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.h),
              child: TextFormField(
                decoration:  InputDecoration(
                  fillColor: Colors.white,
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.blue)
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey)
                  ),
                  suffixIcon: const Icon(Icons.search_outlined),
                  hintText: "Search for products here",
                  hintStyle: TextStyle(fontSize: 15.sp)
                ),
                onChanged: (val){
                  setState(() {
                   inputText = val;
                   print(inputText);
                  });
                },
              ),
            ),
            Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("products").where(
                    "product-name", isGreaterThanOrEqualTo: inputText).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasError){
                      return const Center(
                        child: Text("Something went wrong"),
                      );
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: Text("Loading..."),
                      );
                    }
                    return ListView(
                     children: snapshot.data!.docs
                      .map((DocumentSnapshot document){
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return Card(
                          elevation: 8,
                          child: ListTile(
                           title: Text(data["product-name"],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            leading: Image.network(data["product-img"][0]),
                          )
                        );
                     }).toList(),
                    );
                  },
                )
            ),
          ],
        ),
      ),
    );
  }
}
