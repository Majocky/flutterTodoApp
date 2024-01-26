import 'package:flutter/material.dart';
import 'package:to_do_list/const/constant.dart';
import 'package:to_do_list/logins/login.dart';
import 'package:to_do_list/screens/Home.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController cfullname = TextEditingController();
    TextEditingController cpassword = TextEditingController();

    void addData() async {
      var uri =
          Uri.parse("http://${api}:8080/ToDoApp/maincode/registerUser.php");

      try {
        final response = await http.post(
          uri,
          body: {
            "username": username.text,
            "password": password.text,
            "fullname": cfullname.text,
            "cpassword": cpassword.text,
          },
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = json.decode(response.body);
          bool success = responseData['success'];
          String message = responseData['message'];

          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(success ? 'Success' : 'Error'),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );

          if (success) {
            // Successful registration, navigate to the Home screen
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Home(),
                ),
              );
            });
          }
        } else {
          throw Exception('Failed to load data');
        }
      } catch (error) {
        print(error.toString());
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                TextField(
                  controller: username,
                  decoration: const InputDecoration(
                    hintText: "UserName",
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: cfullname,
                  decoration: const InputDecoration(
                    hintText: "Tinashe Majoki",
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: password,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: cpassword,
                  decoration: const InputDecoration(
                    hintText: "Confirm Password",
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => Login(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerRight,
                      ),
                      child: const Text(
                        'LogIn?',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    child: MaterialButton(
                      onPressed: () {
                        addData();
                        // Adding a delay of 500 milliseconds before navigating
                        // Future.delayed(const Duration(milliseconds: 500), () {
                        //   Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //       builder: (BuildContext context) => Home(),
                        //     ),
                        //   );
                        // });
                      },
                      color: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.black), // Border color
                        borderRadius:
                            BorderRadius.circular(10.0), // Border radius
                      ),
                      minWidth: 100, // Adjust the width as needed
                      height: 40, // Adjust the height as needed
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: const Text("Sign Up"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
