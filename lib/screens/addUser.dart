import 'package:flutter/material.dart';
import 'package:to_do_list/const/constant.dart';
import 'package:to_do_list/screens/Home.dart';
import 'package:to_do_list/screens/navbar.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddUser extends StatelessWidget {
  final String? username;
  const AddUser({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController topic = TextEditingController();
    TextEditingController note = TextEditingController();

    void addData() async {
      var uri = Uri.parse("http://${api}:8080/ToDoApp/maincode/insertData.php");
      DateTime currentDate = DateTime.now();
      String formattedDate = currentDate.toLocal().toString();
      try {
        final response = await http.post(
          uri,
          body: {
            "topic": topic.text,
            "note": note.text,
            "UserCreated": username,
            "datecreated": formattedDate,
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
                  builder: (BuildContext context) => Home(username: username),
                ),
              );
            });
          }
        } else {
          // Handle non-200 status code (e.g., show an error message)
          print('HTTP error: ${response.statusCode}');
        }
      } catch (error) {
        print(error.toString());
        print('name is ${username} ${formattedDate}');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Notes'),
        backgroundColor: Colors.pink,
      ),
      drawer: Navbar(username: username),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true, // Use shrinkWrap to wrap the content
            children: <Widget>[
              TextField(
                controller: topic,
                decoration: const InputDecoration(
                  hintText: "ENTER YOUR TOPIC",
                  labelText: "TOPIC",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: note,
                decoration: const InputDecoration(
                  hintText: "ENTER THE NOT",
                  labelText: "NOTE",
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  child: MaterialButton(
                    onPressed: () {
                      addData();
                    },
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(color: Colors.black), // Border color
                      borderRadius:
                          BorderRadius.circular(10.0), // Border radius
                    ),
                    minWidth: 50, // Adjust the width as needed
                    height: 40, // Adjust the height as needed
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: const Text("Add Data"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
