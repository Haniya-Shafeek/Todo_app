import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/login.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SinupscreenState();
}

class _SinupscreenState extends State<Signupscreen> {
  final TextEditingController emailcntrller = TextEditingController();
  final TextEditingController namecntrller = TextEditingController();
  final TextEditingController passcntrller = TextEditingController();
  final TextEditingController phonecntrller = TextEditingController();
  Future authenticationsignup(
      {required email,
      required name,
      required phone,
      required password,
      required BuildContext context}) async {
    try {
      var ref = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var docid = ref.user!.uid.toString();
      var data = {
        "email": email,
        "name": name,
        "pasword": password,
        "phone": phone,
      };
      var dbref = FirebaseFirestore.instance
          .collection("mydatabase")
          .doc(docid)
          .set(data);
      Fluttertoast.showToast(msg: "Success");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Loginpage(),
          ));
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.code);
    } catch (e) {
      Fluttertoast.showToast(msg: "failed");
    }
  }

  Future databasestore(email, pass, name, phone, docid) async {
    var data = {
      "email": email,
      "pasword": pass,
      "name": name,
      "phone": phone,
    };
    var dbref = await FirebaseFirestore.instance
        .collection("mydatabase")
        .doc(docid)
        .set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/loginimage.png"))),
              ),
              const Text(
                "Register",
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Email",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailcntrller,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Name",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: namecntrller,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Password",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passcntrller,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Phone",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: phonecntrller,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () => authenticationsignup(
                    email: emailcntrller.text,
                    name: namecntrller.text,
                    phone: phonecntrller.text,
                    password: passcntrller.text,
                    context: context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 29),
                  child: Container(
                    height: 40,
                    width: 270,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.green),
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
