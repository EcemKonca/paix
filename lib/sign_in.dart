import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paix_380/login.dart';
import 'package:date_time_picker/date_time_picker.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

Future<User?> signInWithEmailPassword(
    {required String email,
    required String password,
    required BuildContext context}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    user = userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == "email-already-in-use") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email is already in use'),
      ));
    } else if (e.code == "invalid-email") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email is invalid'),
      ));
    }
  }
  return user;
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController birthdayController=TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    birthdayController.dispose();
  }

  String name = "";
  String surname = "";
  String eMail = "";
  String password = "";
  String birthDate = "";

  Future<void> saveInformation() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference<Map<String, dynamic>> a =
        FirebaseFirestore.instance.collection('users').doc(uid);
    await a.set({
      'Name': name,
      'Surname': surname,
      'Email': eMail,
      'BirthDate': birthDate
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('User is saved'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text("Create an Account", textScaleFactor: 2),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                child: const Text(
                  "Enter your first name",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Ecem",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    labelText: 'First Name',
                    prefixIcon: const Icon(Icons.drive_file_rename_outline),
                    labelStyle: const TextStyle(color: Colors.cyan),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'First name cannot be empty.';
                    }
                    if (value.contains(RegExp('[0-9]'))) {
                      return "First name cannot contain numbers.";
                    }
                    if (value.contains(RegExp('[?,!,;,,,.]'))) {
                      return "First name cannot contain punctuation mark.";
                    }
                    return null;
                  },
                  onSaved: (newValue) => name = newValue!,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                child: const Text(
                  "Enter your last name",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                child: TextFormField(
                  controller: lastnameController,
                  decoration: InputDecoration(
                    hintText: "Konca",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    labelText: 'Last Name',
                    prefixIcon: const Icon(Icons.drive_file_rename_outline),
                    labelStyle: const TextStyle(color: Colors.cyan),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name cannot be empty.';
                    }
                    if (value.contains(RegExp('[0-9]'))) {
                      return "Last name cannot contain numbers.";
                    }
                    if (value.contains(RegExp('[?,!,;,,,.]'))) {
                      return "Last name cannot contain punctuation mark.";
                    }
                    return null;
                  },
                  onSaved: (newValue) => surname = newValue!,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                child: const Text(
                  "Select your date of birth",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                child: DateTimePicker(
                  controller: birthdayController,
                  type: DateTimePickerType.date,
                  dateLabelText: 'Pick your date of birth',
                  decoration: InputDecoration(
                      labelText: 'Birth of Date',
                      hintText: "MM/DD/YYYY",
                      labelStyle: const TextStyle(color: Colors.cyan),
                      prefixIcon: const Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90),
                      )),
                  firstDate: DateTime(1930),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Date of birth cannot be empty.";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        birthDate = value;
                      });
                    }
                  },
                  onSaved: (newValue) => birthDate = newValue!,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                child: const Text(
                  "Enter your email address",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "abc@def.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    labelText: 'E-mail',
                    prefixIcon: const Icon(Icons.email),
                    labelStyle: const TextStyle(color: Colors.cyan),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty.';
                    }
                    if (!value.contains("@")) {
                      return 'Email is invalid. It must contain "@". ';
                    }
                    return null;
                  },
                  onSaved: (newValue) => eMail = newValue!,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                child: const Text(
                  "Enter your password",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.password),
                    labelStyle: const TextStyle(color: Colors.cyan),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty.';
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters.";
                    }
                    return null;
                  },
                  onSaved: (newValue) => password = newValue!,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    onPressed: () async {
                      User? user = await signInWithEmailPassword(
                          email: emailController.text,
                          password: passwordController.text,
                          context: context);
                      setState(() {
                        final content = _formKey.currentState?.validate();
                        if (content == true) {
                          _formKey.currentState?.save();
                          saveInformation();
                          if (user != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Login()));
                          }
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      child: const Text(
                        'SIGN UP',
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
    );
  }
}
