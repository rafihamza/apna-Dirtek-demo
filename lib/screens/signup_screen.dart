import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignupScreen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(hintText: "Full name"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: "password"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Confirm password"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var fullName = fullNameController.text.trim();
                var email = emailController.text.trim();
                var password = passwordController.text.trim();
                var confirampass = confirmController.text.trim();
                if (fullName.isEmpty ||
                    email.isEmpty ||
                    password.isEmpty ||
                    confirampass.isEmpty) {
                  // show error  toast
                  Fluttertoast.showToast(msg: 'please fill all fields');
                  return;
                }
                if (password.length < 6) {
                  // show error  toast
                  Fluttertoast.showToast(
                      msg: 'weak password at least 8 characters are required');
                  return;
                }
                if (password != confirampass) {
                  // show error  toast
                  Fluttertoast.showToast(msg: 'password is do not match');
                  return;
                }
                //request to firebase auth
                ProgressDialog progressDialog = ProgressDialog(context,
                    title: const Text("Signing"),
                    message: const Text("please white"));
                progressDialog.show();

                try {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  UserCredential userCredential =
                      await auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                  if (userCredential.user != null) {
                    // store user information in realtime database

                    DatabaseReference userRef =
                        FirebaseDatabase.instance.reference().child("users");
                    String uid = userCredential.user!.uid;
                    int dt = DateTime.now().microsecondsSinceEpoch;

                    await userRef.child(uid).set({
                      'fullName': fullName,
                      'email': email,
                      'uid': uid,
                      'dt': dt,
                      'profileimage': '',
                    });

                    Fluttertoast.showToast(msg: "success");
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } else {
                    Fluttertoast.showToast(msg: "failed");
                  }
                  progressDialog.dismiss();
                } on FirebaseAuthException catch (e) {
                  progressDialog.dismiss();
                  if (e.code == 'email  already in use') {
                    Fluttertoast.showToast(msg: "email  already in use");
                  } else if (e.code == 'weak-password') {
                    Fluttertoast.showToast(msg: 'password is weak');
                  }
                } catch (e) {
                  progressDialog.dismiss();
                  Fluttertoast.showToast(msg: "something went wrong");
                }
              },
              child: const Text("Signup"),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
