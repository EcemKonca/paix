import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paix_380/new_password.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = db
        .collection('users')
        .where('Email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.orange,
            Colors.green,
          ],
        )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: snapshots,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              List<QueryDocumentSnapshot<Object?>> documents =
                  snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = documents[index];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Text("User Details", textScaleFactor: 2.5),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                          child: const Text(
                            "Your Name",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.drive_file_rename_outline),
                          ),
                          title: Text(
                            document['Name'],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                          child: const Text(
                            "Your Surname",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.drive_file_rename_outline),
                          ),
                          title: Text(
                            document['Surname'],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                          child: const Text(
                            "Your email",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.email),
                          ),
                          title: Text(
                            FirebaseAuth.instance.currentUser!.email!,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                          child: const Text(
                            "Your date of birth",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.date_range),
                          ),
                          title: Text(
                            document['BirthDate'],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const NewPassword()));
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(190, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: Text("Change Password".toUpperCase()),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
