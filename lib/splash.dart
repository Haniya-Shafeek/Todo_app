import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/login.dart';

class Spashscreen extends StatefulWidget {
  const Spashscreen({super.key});

  @override
  State<Spashscreen> createState() => _SpashscreenState();
}

class _SpashscreenState extends State<Spashscreen> {
  bool? login;
  void logincheck() async {
    SharedPreferences Preferences = await SharedPreferences.getInstance();
    login = Preferences.getBool("login");
    if (login == null || login == false) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Loginpage(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4)).whenComplete(() => logincheck());
    return const Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Text(
          "TODO APP",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
