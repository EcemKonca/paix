import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paix_380/clothes_model.dart';
import 'package:paix_380/clothes_details.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);
  static List<Clothes> cartList = [];

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final snapshots = FirebaseFirestore.instance
      .collection('Cart')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Page"),
      ),
      body: StreamBuilder(
          stream: snapshots,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            List<QueryDocumentSnapshot<Object?>> documents =
                snapshot.data!.docs;
            num totalPrice = documents
                .fold(0, (total, doc) => total+doc['price']);
            return SingleChildScrollView(
              child: Column(children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = documents[index];
                    Clothes clothes = Clothes.fromMap(documents[index]);
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
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
                        ),
                      ),
                    );
                  },
                  itemCount: documents.length,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${documents.length} Items',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('$totalPrice TL',
                        style: const TextStyle(
                          fontSize: 18,
                        )),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Your order has been received. Thank you!")));
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(205, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text("FINISH ORDER"))
              ]),
            );
          }),
    );
  }
}
