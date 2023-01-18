import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paix_380/homepage.dart';
import 'package:paix_380/cart.dart';
import 'package:paix_380/favorites.dart';
import 'package:paix_380/profile.dart';
import 'clothes_details.dart';
import 'clothes_model.dart';

class Dress extends StatelessWidget {
  const Dress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dresses"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfilePage()));
                },
                iconSize: 32,
                icon: const Icon(Icons.person)),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white70,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  focusColor: Colors.red,
                  icon: const Icon(Icons.home_filled, color: Colors.orange),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Homepage()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.orange),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Favorities()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.orange),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Cart()));
                  },
                ),
              ]),
        ),
        body: Center(
            child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.orange,
                    Colors.pink,
                  ],
                )),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Dresses')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    List<QueryDocumentSnapshot<Object?>> documents =
                        snapshot.data!.docs;
                    return SingleChildScrollView(
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            Clothes dresses = Clothes.fromMap(documents[index]);
                            return DressesInList(clothes: dresses);
                          },
                          itemCount: documents.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            //crossAxisSpacing: 20,
                            //mainAxisSpacing: 20,
                            crossAxisCount: 2,
                          )),
                    );
                  },
                ))));
  }
}

class DressesInList extends StatelessWidget {
  const DressesInList({Key? key, required this.clothes}) : super(key: key);
  final Clothes clothes;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClothesDetails(clothes: clothes))),
      child: Column(
        children: [
          Image.network(
            clothes.image,
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
          Text(
            clothes.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Text(
            '${clothes.price} TL',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          )
        ],
      ),
    );
  }
}
