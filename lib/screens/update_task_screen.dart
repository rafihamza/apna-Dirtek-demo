import 'package:flutter/material.dart';

class updateScreen extends StatelessWidget {
  const updateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("updateScreen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(hintText: "Task Name"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
