import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users-favorite-items")
              .doc(FirebaseAuth.instance.currentUser!.email).collection("items").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.hasError){
              return const Center(
                child:Text("Something went wrong")
              );
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
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
                      style: const TextStyle(color: Colors.redAccent),
                      ),
                      trailing: GestureDetector(
                        child: const CircleAvatar(
                          child: Icon(Icons.remove_circle_outline),
                        ),
                        onTap: (){
                          FirebaseFirestore.instance.collection("users-favorite-items")
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
