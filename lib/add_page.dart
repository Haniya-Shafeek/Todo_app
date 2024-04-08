import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/home.dart';

class Addscreen extends StatefulWidget {
  const Addscreen({super.key});

  @override
  State<Addscreen> createState() => _AddscreenState();
}

class _AddscreenState extends State<Addscreen> {
  final TextEditingController titlecntrller = TextEditingController();
  final TextEditingController aboutntrller = TextEditingController();
  String currentdate = DateFormat("dd MM").format(DateTime.now());
  String currenttime = DateFormat("HH:mm").format(DateTime.now());

  void getdetails() async {
    var ref = FirebaseAuth.instance;
    User user = ref.currentUser!;
    String uid = user.uid;
    await FirebaseFirestore.instance
        .collection("todo_list")
        .doc(uid)
        .collection("mytasks")
        .add({
      "title": titlecntrller.text,
      "about": aboutntrller.text,
      "date": currentdate,
      "time": currenttime
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Add List"),
                InkWell(
                    onTap: () {
                      getdetails();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Homepage(),
                          ));
                    },
                    child: const Text("OK")),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titlecntrller,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Title",
                        hintStyle: TextStyle(fontSize: 30)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(currentdate),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(currenttime),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 500,
                    width: 400,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(30)),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: aboutntrller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "About",
                              hintStyle: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
