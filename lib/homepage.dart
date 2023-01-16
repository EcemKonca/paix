import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paix_380/cart.dart';
import 'package:paix_380/dress.dart';
import 'package:paix_380/Favorites.dart';
import 'package:paix_380/creditCard.dart';
import 'package:paix_380/main.dart';
import 'package:paix_380/address.dart';
import 'package:paix_380/clothes_model.dart';
import 'package:paix_380/bag.dart';
import 'package:paix_380/shoe.dart';
import 'package:paix_380/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paix_380/all_favourites.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController controller = TextEditingController();
  late final Clothes clothes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Center(
                  child: Text(
                "MENU",
                textScaleFactor: 2,
              )),
            ),
            const SizedBox(
              height: 40,
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.location_on_sharp),
              ),
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Adresses", textScaleFactor: 1.5),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Address()));
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.credit_card_rounded),
              ),
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Credit Cards",
                  textScaleFactor: 1.5,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CreditCard()));
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.favorite),
              ),
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Others Favourites",
                  textScaleFactor: 1.5,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AllFavourites()));
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.logout_outlined),
              ),
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Log Out",
                  textScaleFactor: 1.5,
                ),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("LOGGED OUT"),
                  duration: Duration(seconds: 1),
                ));
               // Navigator.popUntil(context,ModalRoute.withName(Navigator.defaultRouteName));
                Navigator.of(context).push(
                   MaterialPageRoute(builder: (context) => const HomePage()));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Homepage"),
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
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
            Widget>[
          IconButton(
              focusColor: Colors.red,
              icon: const Icon(Icons.home_filled, color: Colors.orange),
              onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.orange),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Favorities()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.orange),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Cart()));
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
              Colors.pink,
              Colors.indigoAccent,
            ],
          )),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(9, 25, 9, 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => const Dress()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Dress",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => const Shoe()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Shoe",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => const Bag()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Bag",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                          )),
                    ),
                  ],
                ),
                Center(
                  child: Text("Special Items".toUpperCase(),
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 25)),
                ),
                const SizedBox(
                  height: 10,
                ),
                 const ListOfClothes()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
