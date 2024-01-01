import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var taskController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AddTask"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: const InputDecoration(hintText: "Task Name"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                // ignore: non_constant_identifier_names
                String TaskName = taskController.text.trim();
                if (TaskName.isEmpty) {
                  Fluttertoast.showToast(msg: "pleas provide task name");
                  return;
                }
                User? user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  String uid = user.uid;
                  int dt = DateTime.now().microsecondsSinceEpoch;

                  DatabaseReference taskRef = FirebaseDatabase.instance
                      .reference()
                      .child('Task')
                      .child(uid);
                  String? taskId = taskRef.push().key;
                 await taskRef.child(taskId!).set(
                  {
                    'dt':dt,
                    'taskName':TaskName,
                    'taskId':taskId
                  }
                 );
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
