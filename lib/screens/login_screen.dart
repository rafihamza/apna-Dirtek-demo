import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_new_app/screens/signup_screen.dart';
import 'package:my_new_app/screens/task_list_screen.dart';
import 'package:ndialog/ndialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LoginScreen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
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
            ElevatedButton(
              onPressed: () async {
                var email = emailController.text.trim();
                var password = passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  Fluttertoast.showToast(msg: "Please fill all fields");
                  return;
                }

                ProgressDialog progressDialog = ProgressDialog(
                  context,
                  title: const Text("Logging in"),
                  message: const Text("Please wait"),
                );
                progressDialog.show();

                try {
                  FirebaseAuth auth = FirebaseAuth.instance;

                  UserCredential userCredential =
                      await auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  if (userCredential.user != null) {
                    progressDialog.dismiss();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return const TaskList();
                    }));
                    // Assuming '/taskList' is a named route for TaskList screen
                  }
                } on FirebaseAuthException catch (e) {
                  progressDialog.dismiss();
                  String errorMessage = "Something went wrong";
                  if (e.code == 'user-not-found') {
                    errorMessage = "User not found";
                  } else if (e.code == 'wrong-password') {
                    errorMessage = "Wrong password";
                  }
                  Fluttertoast.showToast(msg: errorMessage);
                } catch (e) {
                  Fluttertoast.showToast(msg: "Something went wrong");
                  progressDialog.dismiss();
                }
              },
              child: const Text("Login"),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not registered yet"),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const SignupScreen();
                      }));
                    },
                    child: const Text("Register Now"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
