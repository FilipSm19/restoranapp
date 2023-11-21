import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  String? _role;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  Future register() async {
    if (passwordConfirmed()) {
      showDialog(
        useRootNavigator: false,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      if (_role != null && context.mounted) {
        FirebaseApp app = await Firebase.initializeApp(
            name: 'Secondary', options: Firebase.app().options);
        try {
          await FirebaseAuth.instanceFor(app: app)
              .createUserWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim());
          await app.delete();
          addUserDetails(_emailController.text.trim(), _role!);
          if (context.mounted) {
            Navigator.of(context).pop(true);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  Future.delayed(const Duration(milliseconds: 1200), () {
                    Navigator.of(context).pop(true);
                    _emailController.clear();
                    _passwordController.clear();
                    _confirmpasswordController.clear();
                    setState(() {
                      _role = null;
                    });
                  });
                  return const AlertDialog(
                    content: Text('User has been added succesfully.'),
                  );
                });
          }
        } on FirebaseAuthException catch (e) {
          if (e.code != 'unknown' && context.mounted) {
            Navigator.of(context).pop(true);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    Navigator.of(context).pop(true);
                  });
                  return AlertDialog(
                    content: Text('${e.message}'),
                  );
                });
          } else {
            Navigator.of(context).pop(true);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    Navigator.of(context).pop(true);
                  });
                  return const AlertDialog(
                    content: Text('Invalid email or password.'),
                  );
                });
          }
        }
      } else {
        Navigator.of(context).pop(true);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              Future.delayed(const Duration(milliseconds: 2200), () {
                Navigator.of(context).pop(true);
              });
              return const AlertDialog(
                content: Text(
                    'Please check the fields have been correctly filled in.'),
              );
            });
      }
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            Future.delayed(const Duration(milliseconds: 2000), () {
              Navigator.of(context).pop(true);
            });
            return const AlertDialog(
              content: Text('The password confirmation does not match.'),
            );
          });
    }
  }

  Future addUserDetails(String email, String role) async {
    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'role': role,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(
                Icons.group_add,
                size: 50,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Dodavanje novog zaposlenika',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const SizedBox(height: 30),
              //email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Email'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Lozinka',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //confirm password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _confirmpasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Potvrdi lozinku',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      hint: const Text('Uloga'),
                      isExpanded: true,
                      isDense: true,
                      value: _role,
                      items: ['Konobar', 'Kuhar', 'Admin']
                          .map((item) => DropdownMenuItem<String>(
                              value: item, child: Text(item)))
                          .toList(),
                      onChanged: (item) => setState(() => _role = item),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              //register button
              GestureDetector(
                onTap: register,
                child: Container(
                  height: 60,
                  width: 100,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 67, 160, 39),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green)),
                  child: const Center(
                      child: Wrap(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        textAlign: TextAlign.center,
                        ' Dodaj',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  )),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
