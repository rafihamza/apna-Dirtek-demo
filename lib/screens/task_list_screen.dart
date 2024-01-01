import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_new_app/screens/login_screen.dart';
import 'package:my_new_app/screens/profile_screen.dart';

import 'add_task_screen.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  User? user;
  DatabaseReference? taskRef;


  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      taskRef =
          FirebaseDatabase.instance.reference().child('Task').child(user!.uid);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TaskList"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const ProfileScreen();
              }));
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text("Confirmation !!!"),
                    content: const Text("Are you sure to log out"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("NO"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          FirebaseAuth.instance.signOut();

                          Navigator.of(ctx).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }),
                          );
                        },
                        child: const Text("YES"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const AddTask();
          }));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: taskRef != null ? taskRef!.onValue : null,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            DataSnapshot data = snapshot.data!.snapshot;
            if (data.value == null) {
              return Center(
                child: Text("No tasks available"),
              );
            } else {
              List<dynamic> tasks = snapshot as List<dynamic>;

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  // Assuming each task is a map with 'taskName' field
                  return ListTile(
                    title: Text(tasks[index]['taskName'] ?? 'No Task Name'),
                    // Other details or widgets related to each task
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
