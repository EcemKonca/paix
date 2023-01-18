import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'clothes_model.dart';
import 'package:paix_380/cart.dart';
import 'package:paix_380/favorites.dart';

class ClothesDetails extends StatefulWidget {
  const ClothesDetails({Key? key, required this.clothes}) : super(key: key);
  final Clothes clothes;

  @override
  State<ClothesDetails> createState() => _ClothesDetailsState();
}

class _ClothesDetailsState extends State<ClothesDetails> {
  bool isFavourited = false;
  bool isCart = false;

  User? currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference favoritesCollection =
      FirebaseFirestore.instance.collection('favourites');
  CollectionReference clothesCollection =
      FirebaseFirestore.instance.collection('Clothes');
  CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('Cart');

  saveFav() {
    if (currentUser != null) {
      favoritesCollection.add({
        'userId': currentUser!.uid,
        'userEmail':currentUser!.email,
        'itemId': clothesCollection.id,
        'name': widget.clothes.name,
        'image': widget.clothes.image,
        'price': widget.clothes.price,
        'count': widget.clothes.count,
        'size': widget.clothes.size,
        'isFavouriteAdded': widget.clothes.isFavouriteAdded,
        'isCartAdded': widget.clothes.isCartAdded,
        'description': widget.clothes.description
      });
    }
  }

  saveCart() {
    if (currentUser != null) {
      cartCollection.add({
        'userId': currentUser!.uid,
        'itemId': clothesCollection.id,
        'name': widget.clothes.name,
        'image': widget.clothes.image,
        'price': widget.clothes.price,
        'count': widget.clothes.count,
        'size': widget.clothes.size,
        'isFavouriteAdded': widget.clothes.isFavouriteAdded,
        'isCartAdded': widget.clothes.isCartAdded,
        'description': widget.clothes.description
      });
    }
  }

  removeFavourite(Clothes clothes) async {
    favoritesCollection
        .where('userId', isEqualTo: currentUser!.uid)
        .where('image', isEqualTo: clothes.image)
        .get()
        .then((QuerySnapshot snapshot) async => {
              for (var document in snapshot.docs)
                {await favoritesCollection.doc(document.reference.id).delete()}
            });
  }

  removeCart(Clothes clothes) async {
    cartCollection
        .where('userId', isEqualTo: currentUser!.uid)
        .where('image', isEqualTo: clothes.image)
        .get()
        .then((QuerySnapshot snapshot) async => {
              for (var document in snapshot.docs)
                {await cartCollection.doc(document.reference.id).delete()}
            });
  }

  @override
  Widget build(BuildContext context) {
    void like() {
      setState(() {
        if (isFavourited) {
          isFavourited = false;
        } else {
          isFavourited = true;
        }
      });
    }

    void shopping() {
      setState(() {
        if (isCart) {
          isCart = false;
        } else {
          isCart = true;
        }
      });
    }

    void addFavorite(Clothes clothe) {
      setState(() {
        if (clothe.isFavouriteAdded) {
          Favorities.favList.remove(clothe);
          clothe.isFavouriteAdded = false;
          removeFavourite(clothe);
        } else {
          Favorities.favList.add(clothe);
          clothe.isFavouriteAdded = true;
          saveFav();
        }
      });
    }

    void addCart(Clothes clothe) {
      setState(() {
        if (clothe.isCartAdded) {
          Cart.cartList.remove(clothe);
          clothe.isCartAdded = false;
          removeCart(clothe);
        } else {
          Cart.cartList.add(clothe);
          clothe.isCartAdded = true;
          saveCart();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Page"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Favorities()));
              },
              iconSize: 28,
              icon: const Icon(Icons.favorite)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Cart()));
              },
              iconSize: 28,
              icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.indigo,
                Colors.pink,
              ],
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.network(
                      widget.clothes.image,
                      width: 250,
                      height: 300,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.clothes.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${widget.clothes.price} TL',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Size: ${widget.clothes.size}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.clothes.description,
                    textScaleFactor: 1.5,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                    icon: AnimatedCrossFade(
                      firstChild: const Icon(Icons.favorite, size: 27),
                      secondChild: const Icon(Icons.favorite_border, size: 27),
                      crossFadeState: widget.clothes.isFavouriteAdded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstCurve: Curves.easeIn,
                      secondCurve: Curves.easeOut,
                      sizeCurve: Curves.easeInOut,
                      duration: const Duration(seconds: 2),
                    ),
                    onPressed: () {
                      like();
                      addFavorite(widget.clothes);
                    },
                    label: AnimatedCrossFade(
                      firstChild: const Text(" Added to Favorites   ",
                          style: TextStyle(fontSize: 17)),
                      secondChild: const Text("   Add to Favorites   ",
                          style: TextStyle(fontSize: 17)),
                      crossFadeState: widget.clothes.isFavouriteAdded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstCurve: Curves.bounceIn,
                      secondCurve: Curves.bounceOut,
                      sizeCurve: Curves.bounceInOut,
                      duration: const Duration(seconds: 2),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(235, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    )),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ElevatedButton.icon(
                      icon: AnimatedCrossFade(
                        firstChild:
                            const Icon(Icons.shopping_cart_rounded, size: 27),
                        secondChild:
                            const Icon(Icons.add_shopping_cart, size: 27),
                        crossFadeState: widget.clothes.isCartAdded
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstCurve: Curves.easeIn,
                        secondCurve: Curves.easeOut,
                        sizeCurve: Curves.easeInOut,
                        duration: const Duration(seconds: 2),
                      ),
                      onPressed: () {
                        shopping();
                        addCart(widget.clothes);
                      },
                      label: AnimatedCrossFade(
                        firstChild: const Text(" Added to Cart   ",
                            style: TextStyle(fontSize: 17)),
                        secondChild: const Text("   Add to Cart   ",
                            style: TextStyle(fontSize: 17)),
                        crossFadeState: widget.clothes.isCartAdded
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstCurve: Curves.bounceIn,
                        secondCurve: Curves.bounceOut,
                        sizeCurve: Curves.bounceInOut,
                        duration: const Duration(seconds: 2),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(235, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
