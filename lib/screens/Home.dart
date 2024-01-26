import 'package:flutter/material.dart';
import 'package:to_do_list/const/constant.dart';
import 'package:to_do_list/screens/editDataScreen.dart';
import 'package:to_do_list/screens/navbar.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  final String? username;
  const Home({Key? key, this.username}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List> getData() async {
    var uri = Uri.parse("http://${api}:8080/ToDoApp/maincode/getdata.php");

    try {
      final response = await http.post(
        uri,
        body: {
          "username": widget.username,
        },
      );

      // Check if the response status code is successful (status code 200)
      if (response.statusCode == 200) {
        // Parse and return the response body
        return json.decode(response.body);
        print(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle any other errors that might occur during the request
      print(error.toString());
      // Return an empty list or handle the error as needed
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Navbar(username: widget.username),
        appBar: AppBar(
          title: widget.username != null
              ? Text('Welcome ${widget.username}')
              : Text('Welcome'),
          backgroundColor: Colors.pink,
        ),
        body: FutureBuilder<List>(
            future: getData(),
            builder: (ctx, ss) {
              if (ss.hasError) {
                print(ss.error);
              }
              if (ss.hasData) {
                return Items(list: ss.data!);
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}

class Items extends StatelessWidget {
  final List list;

  // Use super.key for the key parameter
  Items({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (ctx, i) {
        // Get the first 10 characters of the subtitle
        String shortSubtitle = (list[i]['note'] as String).substring(0, 1);
        return ListTile(
          leading: const Icon(Icons.message),
          title: Text(list[i]['topic']),
          subtitle: Text(shortSubtitle), // Display only the first 10 characters
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => EditData(list: list, index: i),
            ),
          ),
        );
      },
    );
  }
}
