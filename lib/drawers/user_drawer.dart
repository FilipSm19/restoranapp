import 'package:flutter/material.dart';
import '../home.dart';
import '../login/login.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        const SizedBox(height: 70),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Početna stranica', style: TextStyle(fontSize: 16)),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Home(0)));
          },
        ),
        ListTile(
          leading: const Icon(Icons.menu_book),
          title: const Text('Meni', style: TextStyle(fontSize: 16)),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Home(1)));
          },
        ),
        ListTile(
          leading: const Icon(Icons.supervisor_account),
          title: const Text('Log in', style: TextStyle(fontSize: 16)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
        ),
      ],
    ));
  }
}
