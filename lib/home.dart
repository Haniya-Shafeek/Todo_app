import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/add_page.dart';
import 'package:todo_app/edit.dart';
import 'package:todo_app/login.dart';
import 'package:todo_app/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late User? _curretuser;
  String email = "";
  String name = "";
  String pass = "";
  String phone = "";
  String _uid = "";
  void getuid() {
    var ref = FirebaseAuth.instance;
    User user = ref.currentUser!;
    setState(() {
      _uid = user.uid;
    });
  }

  

  void getdetails() async {
    _curretuser = FirebaseAuth.instance.currentUser;

    if (_curretuser != null) {
      fetchdetails();
    }
  }

  void fetchdetails() async {
    DocumentSnapshot usersnapshot = await FirebaseFirestore.instance
        .collection("mydatabase")
        .doc(_curretuser!.uid)
        .get();
    setState(() {
      name = usersnapshot["name"];
      email = usersnapshot["email"];
      pass = usersnapshot["pasword"];
      phone = usersnapshot["phone"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuid();
    getdetails();
    fetchdetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TO DO"),
          backgroundColor: Colors.amber,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Addscreen(),
                ));
          },
          child: const Icon(Icons.add),
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQESgEgkgFa6JBZxS_lIO7glUy3SWRmbfO4K7sTq6_1NA&s'), // Replace this with the actual path of the profile picture
                ),
                const SizedBox(height: 30.0),
                Text(
                  'Name: $name', // Replace with actual user name
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Email: $email', // Replace with actual user email
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Password: $pass', // Replace with actual user location
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Phone: $phone', // Replace with actual user location
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                    onPressed: () async{
                       SharedPreferences Preferences = await SharedPreferences.getInstance();
        Preferences.setBool("login", false);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Loginpage(),
                          ));
                    },
                    child: const Text(
                      "log out",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    )),
                TextButton(
                    onPressed: () async{
                      try {
                        SharedPreferences Preferences = await SharedPreferences.getInstance();
        Preferences.setBool("login", false);
                     _curretuser = FirebaseAuth.instance.currentUser;
                      await _curretuser!.delete();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Signupscreen(),
                          ));
                    } catch (e) {
                      print(e);
                    }
                    }
                    ,
                    child: const Text(
                      "Delete Account",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ))
              ],
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("todo_list")
              .doc(_uid)
              .collection("mytasks")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 2))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 130,
                            width: 60,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10),
                                    top: Radius.circular(10)),
                                color: Colors.amber),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(snapshot.data!.docs[index]["date"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal)),
                                  Text(snapshot.data!.docs[index]["time"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal))
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.docs[index]["title"],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(snapshot.data!.docs[index]["about"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal))
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Editpage(
                                              docid: snapshot
                                                  .data!.docs[index].id),
                                        ));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.amber,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("todo_list")
                                        .doc(_uid)
                                        .collection("mytasks")
                                        .doc(snapshot.data!.docs[index].id)
                                        .delete();
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text("error");
            }
          },
        ),
      ),
    );
  }
}
