import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  Future<void> saveAddress() async {
    DocumentReference<Map<String, dynamic>> addressInfo = FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    await addressInfo.update({
      'address': {
        'name': name,
        'surname': surname,
        'City': city,
        'District': district,
        'Neighbourhood': neighbourhood,
        'Street': street,
        'Address': address,
        'Phone': phone
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Address is saved'),
    ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController(); // add controllers
  String name = "";
  String surname = "";
  String city = "";
  String district = "";
  String neighbourhood = "";
  String street = "";
  String address = "";
  String phone = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address"),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.green,
                Colors.amber,
              ],
            )),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 55, 10, 30),
                  child: Text("Address Information", textScaleFactor: 2),
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: const Text(
                        "Name",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: const Text(
                          "Surname",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Ecem",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                            labelText: 'First Name',
                            prefixIcon:
                                const Icon(Icons.drive_file_rename_outline),
                            labelStyle: const TextStyle(color: Colors.purple),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Name cannot be empty.';
                            }
                            if (value.contains(RegExp('[0-9]'))) {
                              return "Name cannot contain numbers.";
                            }
                            if (value.contains(RegExp('[?,!,;,,,.]'))) {
                              return "Name cannot contain punctuation mark.";
                            }
                            return null;
                          },
                          onSaved: (newValue) => name = newValue!,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Konca",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                            labelText: 'Last Name',
                            prefixIcon:
                                const Icon(Icons.drive_file_rename_outline),
                            labelStyle: const TextStyle(color: Colors.purple),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Surname cannot be empty.';
                            }
                            if (value.contains(RegExp('[0-9]'))) {
                              return "Surname cannot contain numbers.";
                            }
                            if (value.contains(RegExp('[?,!,;,,,.]'))) {
                              return "Surname cannot contain punctuation mark.";
                            }
                            return null;
                          },
                          onSaved: (newValue) => surname = newValue!,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
                        child: const Text("City",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
                        child: const Text("District",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Izmir",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                              labelText: 'City Name',
                              prefixIcon: const Icon(Icons.location_city),
                              labelStyle: const TextStyle(color: Colors.purple),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'City cannot be empty.';
                              }
                              if (!value.contains(RegExp('[a-zA-Z]'))) {
                                return "City can contain only letters.";
                              }
                              return null;
                            },
                            onSaved: (newValue) => city = newValue!,
                          )),
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Balçova",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                              labelText: 'District Name',
                              prefixIcon: const Icon(Icons.location_city_sharp),
                              labelStyle: const TextStyle(color: Colors.purple),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'District cannot be empty.';
                              }
                              if (!value.contains(RegExp('[a-zA-Z]'))) {
                                return "District can contain only letters.";
                              }
                              return null;
                            },
                            onSaved: (newValue) => district = newValue!,
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
                        child: const Text("Neighbourhood",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
                        child: const Text("Street",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Fevzi Çakmak",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                              labelText: 'Neighbourhood Name',
                              prefixIcon: const Icon(Icons.location_city),
                              labelStyle: const TextStyle(color: Colors.purple),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Neighbourhood cannot be empty.';
                              }
                              if (!value.contains(RegExp('[a-zA-Z]'))) {
                                return "Neighbourhood can contain only letters.";
                              }
                              return null;
                            },
                            onSaved: (newValue) => neighbourhood = newValue!,
                          )),
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Ata Street",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                              labelText: 'Street Name',
                              prefixIcon: const Icon(Icons.location_city_rounded),
                              labelStyle: const TextStyle(color: Colors.purple),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Street cannot be empty.';
                              }
                              if (!value.contains(RegExp('[a-zA-Z]'))) {
                                return "Street can contain only letters.";
                              }
                              return null;
                            },
                            onSaved: (newValue) => street = newValue!,
                          )),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
                  child: const Text("Address",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Evren Apartment, 6.Floor, Suite No:12 ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                        labelText: 'Apartment, Floor, Suite Number, etc',
                        prefixIcon: const Icon(Icons.location_city_sharp),
                        labelStyle: const TextStyle(color: Colors.purple),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Address cannot be empty.';
                        }
                        return null;
                      },
                      onSaved: (newValue) => address = newValue!,
                    )),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
                  child: const Text("Phone",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "05309995555 ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone_sharp),
                        labelStyle: const TextStyle(color: Colors.purple),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number cannot be empty.';
                        }
                        if (!value.contains(RegExp('[0-9]'))) {
                          return 'Phone number can contain only digits.';
                        }
                        if (value.length != 11) {
                          return 'Phone number must contain 11 digits.';
                        }
                        return null;
                      },
                      onSaved: (newValue) => phone = newValue!,
                    )),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        backgroundColor: const Color(0xff1b447b),
                      ),
                      onPressed: () async {
                        setState(() {
                          final content = _formKey.currentState?.validate();
                          if (content == true) {
                            _formKey.currentState?.save();
                            saveAddress();
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        child: const Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
