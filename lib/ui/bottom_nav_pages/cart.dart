import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
         child: StreamBuilder(
           stream: FirebaseFirestore.instance.collection("users-cart-items")
               .doc(FirebaseAuth.instance.currentUser!.email).collection("items").snapshots(),
           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
             if(snapshot.hasError){
               return const Center(
                 child: CircularProgressIndicator(),
               );
             }
             if(snapshot.connectionState == ConnectionState.waiting){
               return const Center(
                 child: Text("Loading"),
               );
             }
             return ListView.builder(
                 itemCount: snapshot.data!.docs.length,
                 itemBuilder: (_, index){
                   DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                  return Card(
                    elevation: 8,
                    child: ListTile(
                      leading: Text(documentSnapshot["name"]),
                      title: Text("${documentSnapshot["price"]}",
                        style: const TextStyle(color: Colors.redAccent),),
                      trailing: GestureDetector(
                        child: const CircleAvatar(
                          child: Icon(Icons.remove_circle),
                        ),
                        onTap: (){
                          FirebaseFirestore.instance.collection("users-cart-items")
                              .doc(FirebaseAuth.instance.currentUser!.email).collection("items")
                              .doc(documentSnapshot.id).delete();
                        },
                      ),
                    ),
                  );
                 }
             );
           },
         ),
      ),
    );
  }
}
