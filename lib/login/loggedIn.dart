import 'package:RestoranApp/home.dart';
import 'package:RestoranApp/roles/konobar.dart';
import 'package:RestoranApp/roles/kuhar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/admin/admin.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Drawer(),
        appBar: AppBar(
          title: const Text('Restoran'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 28,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()));
  }
}

class LoggedIn extends StatelessWidget {
  const LoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        if (snapshot.hasData) {
          return const Role();
        } else {
          return const Home(0);
        }
      },
    ));
  }
}

class Role extends StatelessWidget {
  const Role({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;
    final User? user = auth.currentUser;
    final userEmail = user!.email;

    return FutureBuilder(
        future: db
            .collection('users')
            .doc(userEmail)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            var role = documentSnapshot.get('role') as String;
            return role;
          } else {
            return 'user';
          }
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (snapshot.data == 'Admin') {
            return const AdminPage(0);
          } else if (snapshot.data == 'Konobar') {
            return const KonobarPage(0);
          } else if (snapshot.data == 'Kuhar') {
            return KuharPage(0);
          } else {
            return const Home(0);
          }
        });
  }
}
