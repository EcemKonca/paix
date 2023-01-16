import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'clothes_details.dart';

class Clothes {
  Clothes(
      {required this.count,
      required this.size,
      required this.name,
      required this.isFavouriteAdded,
      required this.isCartAdded,
      required this.image,
      required this.price,
      required this.description});

  final int count;
  bool isFavouriteAdded;
  bool isCartAdded;
  final String size;
  final String name;
  final String image;
  final int price;
  final String description;

  static Clothes fromMap(DocumentSnapshot<Object?> map) {
    return Clothes(
        count: map['count'] as int,
        name: map['name'] as String,
        image: map['image'] as String,
        price: map['price'] as int,
        description: map['description'] as String,
        size: map['size'] as String,
        isFavouriteAdded: map['isFavouriteAdded'] as bool,
        isCartAdded: map['isCartAdded'] as bool);
  }
}

class ListOfClothes extends StatelessWidget {
  const ListOfClothes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Clothes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        List<QueryDocumentSnapshot<Object?>> documents = snapshot.data!.docs;
        return SingleChildScrollView(
          child: GridView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                Clothes clothes = Clothes.fromMap(documents[index]);
                return ClothesInList(clothes: clothes);
              },
              itemCount: documents.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //crossAxisSpacing: 20,
                //mainAxisSpacing: 20,
                crossAxisCount: 2,
              )),
        );
      },
    );
  }
}

class ClothesInList extends StatelessWidget {
  const ClothesInList({Key? key, required this.clothes}) : super(key: key);
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
