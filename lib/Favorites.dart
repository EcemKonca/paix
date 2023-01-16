import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paix_380/clothes_model.dart';
import 'package:paix_380/clothes_details.dart';

class Favorities extends StatefulWidget {
  const Favorities({Key? key}) : super(key: key);
  static List<Clothes> favList = [];

  @override
  State<Favorities> createState() => _FavoritiesState();
}

class _FavoritiesState extends State<Favorities> {
  final snapshots = FirebaseFirestore.instance
      .collection('favourites')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Items"),
      ),
      body: StreamBuilder(
          stream: snapshots,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            List<QueryDocumentSnapshot<Object?>> documents =
                snapshot.data!.docs;
            return SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  DocumentSnapshot document = documents[index];
                  Clothes clothes = Clothes.fromMap(documents[index]);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ClothesDetails(clothes: clothes))),
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.network(
                                document['image'],
                                width: 110,
                                height: 110,
                                fit: BoxFit.fill,
                              ),
                              Text(
                                document['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                '${document['price']} TL',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ]),
                      ),
                    ),
                  );
                },
                itemCount: documents.length,
              ),
            );
          }),
    );
  }
}
