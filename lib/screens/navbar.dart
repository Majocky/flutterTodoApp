import 'package:flutter/material.dart';
import 'package:to_do_list/screens/Home.dart';
import 'package:to_do_list/screens/addUser.dart';

class Navbar extends StatelessWidget {
  final String? username;
  const Navbar({Key? key, this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Center(
              child: UserAccountsDrawerHeader(
                accountName: Text('Tinashe Majoki'),
                accountEmail: Text('tnashemajoky@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(child: Image.asset('assets/images/pic.jpeg')),
                ),
                decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    image: DecorationImage(
                        image: AssetImage('assets/images/book.png'),
                        fit: BoxFit.cover)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Home(username: username),
                ));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Note'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      AddUser(username: username),
                ));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
              onTap: () => print('Settings Tapped'),
            ),
          ],
        ),
      ),
    );
  }
}
