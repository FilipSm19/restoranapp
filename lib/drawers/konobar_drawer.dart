import 'package:RestoranApp/roles/konobar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/main.dart';

class KonobarDrawer extends StatelessWidget {
  KonobarDrawer({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 70),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Početna stranica',
                    style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => KonobarPage(0)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Meni', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => KonobarPage(1)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_alt),
                title: const Text('Narudžbe', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => KonobarPage(2)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.done_all),
                title:
                    const Text('Gotova jela', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => KonobarPage(3)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log out', style: TextStyle(fontSize: 16)),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const MyApp()));
                },
              ),
            ],
          ),
        ),
        Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              children: <Widget>[
                const Divider(),
                ListTile(title: Text('Logged in as: ${user!.email!} (konobar)'))
              ],
            )),
        const SizedBox(height: 10)
      ],
    ));
  }
}
