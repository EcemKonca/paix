import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'clothes_model.dart';

class AllFavourites extends StatefulWidget {
  const AllFavourites({Key? key}) : super(key: key);
  static List<Clothes> favList = [];

  @override
  State<AllFavourites> createState() => _FavoritiesState();
}

class _FavoritiesState extends State<AllFavourites> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = FirebaseFirestore.instance
      .collection('favourites')
      .where('userId', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Others Favourites"),
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: ListTile(
                        title: Row(
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              Text(
                                '${document['price']} TL',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ]),
                        subtitle: Row(
                          children: [
                            const Text(
                              "Favourited by: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              document['userEmail'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
