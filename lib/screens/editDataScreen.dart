import 'package:flutter/material.dart';
import 'package:to_do_list/const/constant.dart';
import 'package:to_do_list/screens/Home.dart';
import 'package:to_do_list/screens/navbar.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditData extends StatefulWidget {
  List list;
  int index;
  EditData({Key? key, required this.list, required this.index})
      : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  late TextEditingController ctopic;
  late TextEditingController cnotes;
  void editData() async {
    var uri = Uri.parse("http://${api}:8080/ToDoApp/maincode/editData.php");
    DateTime currentDate = DateTime.now();
    String formattedDate = currentDate.toLocal().toString();
    try {
      final response = await http.post(
        uri,
        body: {
          "id": widget.list[widget.index]['id'],
          "note": cnotes.text,
          "topic": ctopic.text,
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
                builder: (BuildContext context) =>
                    Home(username: widget.list[widget.index]['UserCreated']),
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
      print(
          ' printing data of -------${widget.list[widget.index]['UserCreated']}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    ctopic = TextEditingController(text: widget.list[widget.index]['topic']);
    cnotes = TextEditingController(text: widget.list[widget.index]['note']);
    super.initState();
  }

  void delete() async {
    var uri = Uri.parse("http://${api}:8080/ToDoApp/maincode/delete.php");
    try {
      final response = await http.post(
        uri,
        body: {
          "id": widget.list[widget.index]['id'],
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
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    Home(username: widget.list[widget.index]['UserCreated']),
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
      print(
          ' printing data of -------${widget.list[widget.index]['UserCreated']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Notes'),
        backgroundColor: Colors.pink,
      ),
      drawer: Navbar(username: widget.list[widget.index]['UserCreated']),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true, // Use shrinkWrap to wrap the content
            children: <Widget>[
              TextField(
                controller: ctopic,
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
                controller: cnotes,
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
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Adjust this based on your layout needs
                children: [
                  Container(
                    child: MaterialButton(
                      onPressed: () {
                        editData();
                        // Adding a delay of 500 milliseconds before navigating
                        Future.delayed(Duration(milliseconds: 500), () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => Home(
                                username: widget.list[widget.index]
                                    ['UserCreated'],
                              ),
                            ),
                          );
                        });
                      },
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.black,
                        ), // Border color
                        borderRadius:
                            BorderRadius.circular(10.0), // Border radius
                      ),
                      minWidth: 50, // Adjust the width as needed
                      height: 40, // Adjust the height as needed
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: const Text("Edit Data"),
                    ),
                  ),
                  Container(
                    child: MaterialButton(
                      onPressed: () {
                        delete();
                        // Adding a delay of 500 milliseconds before navigating
                      },
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.black,
                        ), // Border color
                        borderRadius:
                            BorderRadius.circular(10.0), // Border radius
                      ),
                      minWidth: 50, // Adjust the width as needed
                      height: 40, // Adjust the height as needed
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: const Text("Delete"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
