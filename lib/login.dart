import 'package:flutter/material.dart';
import 'package:paix_380/homepage.dart';
import 'package:paix_380/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

Future<User?> logInUsingEmailPassword(
    {required String email,
    required String password,
    required BuildContext context}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  try {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    user = userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == "user-not-found") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User is not found'),
      ));
    }
  }
  return user;
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(40, 95, 40, 20),
                child: Text("Welcome Back", textScaleFactor: 2),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "abc@def.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    prefixIcon: const Icon(Icons.email),
                    // prefixIcon or Icon ?
                    labelText: 'E-mail',
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
                  onSaved: (newValue) => email = newValue!,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    prefixIcon: const Icon(Icons.password),
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.cyan),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "This area cannot be empty." : null,
                  onSaved: (newValue) => password = newValue!,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 80,
                width: 200,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: Text("Login".toUpperCase(),
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () async {
                    User? user = await logInUsingEmailPassword(
                        email: emailController.text,
                        password: passwordController.text,
                        context: context);
                    setState(() {
                      final content = _formKey.currentState?.validate();
                      if (content == true) {
                        _formKey.currentState?.save();
                        if (user != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Homepage()));
                        }
                      }
                    });
                  },
                ),
              ),
              Container(
                height: 85,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: Text("Forgot Password".toUpperCase(),
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForgotPassword()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
