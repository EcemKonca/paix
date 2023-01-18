import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paix_380/profile.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String newPassword = "";

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Password"),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(40, 105, 40, 20),
                  child: Text("NEW PASSWORD", textScaleFactor: 2),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Text("Enter your new password", textScaleFactor: 1.3),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      prefixIcon: const Icon(Icons.password),
                      labelText: "New Password",
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
                    onSaved: (newValue) => newPassword = newValue!,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: TextFormField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      prefixIcon: const Icon(Icons.password),
                      labelText: "Confirm Password",
                      labelStyle: const TextStyle(color: Colors.cyan),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty.';
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters.";
                      }
                      if (value != passwordController.text) {
                        return "Passwords must be the same.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(190, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          final content = _formKey.currentState?.validate();
                          if (content == true) {
                            _formKey.currentState?.save();
                            newPassword = passwordController.text;
                            resetPassword();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProfilePage()));
                          }
                        });
                      },
                      child: Text("change password".toUpperCase())),
                )
              ],
            )),
      ),
    );
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password is changed'),
      ));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password is not changed"),
      ));
    }
  }
}
