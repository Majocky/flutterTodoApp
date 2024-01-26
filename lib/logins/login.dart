import 'package:flutter/material.dart';
import 'package:to_do_list/const/constant.dart';
import 'package:to_do_list/logins/register.dart';
import 'package:to_do_list/screens/Home.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();

    void isLogIn() async {
      var uri = Uri.parse("http://${api}:8080/ToDoApp/maincode/LoginUser.php");

      try {
        final response = await http.post(
          uri,
          body: {
            "username": username.text,
            "password": password.text,
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
            String usernames = username.text;
            // Successful registration, navigate to the Home screen
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Home(username: usernames),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.edit,
                //   size: 80,
                //   color: Colors.white,
                // ),
                const Image(
                  image: AssetImage('assets/images/login.png'),
                ),
                const SizedBox(height: 20),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerRight,
                      ),
                      child: const Text(
                        'Forgot Password?',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => Register(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerRight,
                      ),
                      child: const Text(
                        'Is the New User?',
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
                        // Adding a delay of 500 milliseconds before navigating
                        isLogIn();
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
                      child: const Text("Log In"),
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
