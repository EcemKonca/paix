import 'package:flutter/material.dart';
import 'package:paix_380/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(40, 105, 40, 20),
                child: Text("RESET PASSWORD", textScaleFactor: 2),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text("To reset your password, we send an email to you.",
                    textScaleFactor: 1.3),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
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
                          resetPassword();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Login()));
                        }
                      });
                    },
                    child: Text("Send Email".toUpperCase(),
                        style: const TextStyle(fontSize: 17))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email is sent'),
      ));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email is not found"),
      ));
    }
  }
}
