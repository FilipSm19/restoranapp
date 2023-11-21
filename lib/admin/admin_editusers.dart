import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditUsersPage extends StatefulWidget {
  const EditUsersPage({super.key});

  @override
  State<EditUsersPage> createState() => _EditUsersPageState();
}

class _EditUsersPageState extends State<EditUsersPage> {
  List<String> docIDs = [];
  String? _role;

  Future getDocId() async {
    docIDs.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              docIDs.add(element.reference.id);
            }));
  }

  Future deleteUser(String email) async {
    await FirebaseFirestore.instance.collection('users').doc(email).delete();
  }

  Future editUserDetails(String email, String role) async {
    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'role': role,
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uređivanje zaposlenika'),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: getDocId(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Material(
                            color: const Color.fromARGB(255, 248, 252, 218),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                tileColor:
                                    const Color.fromARGB(255, 237, 241, 199),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          docIDs[index],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        FutureBuilder<DocumentSnapshot>(
                                          future:
                                              users.doc(docIDs[index]).get(),
                                          builder: ((context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else if (snapshot
                                                    .connectionState ==
                                                ConnectionState.done) {
                                              Map<String, dynamic> data =
                                                  snapshot.data!.data()
                                                      as Map<String, dynamic>;
                                              return Text(
                                                ' (${data['role']})'
                                                    .toLowerCase(),
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 12),
                                              );
                                            }
                                            return const Text('');
                                          }),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Center(
                                        child: SizedBox(
                                          width: 50,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      _role = null;
                                                      return AlertDialog(
                                                          title: const Text(
                                                              'Promijeni ulogu'),
                                                          content: DropdownButtonFormField<String>(
                                                              hint: const Text(
                                                                  'Uloga'),
                                                              isExpanded: true,
                                                              isDense: true,
                                                              value: _role,
                                                              items: [
                                                                'Konobar',
                                                                'Kuhar',
                                                                'Admin'
                                                              ]
                                                                  .map((item) => DropdownMenuItem<
                                                                          String>(
                                                                      value:
                                                                          item,
                                                                      child: Text(
                                                                          item)))
                                                                  .toList(),
                                                              onChanged:
                                                                  (item) =>
                                                                      _role =
                                                                          item),
                                                          actions: <Widget>[
                                                            TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17),
                                                                )),
                                                            TextButton(
                                                              onPressed: () {
                                                                if (_role !=
                                                                    null) {
                                                                  editUserDetails(
                                                                      docIDs[
                                                                          index],
                                                                      _role!);
                                                                  setState(() =>
                                                                      Navigator.pop(
                                                                          context));
                                                                } else {
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              },
                                                              child: const Text(
                                                                  'OK',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17)),
                                                            ),
                                                          ]);
                                                    });
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                size: 18,
                                              )),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 55,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Brisanje zaposlenika'),
                                                    content: RichText(
                                                        text: TextSpan(
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black),
                                                            children: <TextSpan>[
                                                          const TextSpan(
                                                              text:
                                                                  'Izbrisati '),
                                                          TextSpan(
                                                              text:
                                                                  docIDs[index],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .blue)),
                                                          const TextSpan(
                                                              text: '?')
                                                        ])),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: const Text(
                                                            'Odustani',
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          )),
                                                      TextButton(
                                                          onPressed: () {
                                                            deleteUser(
                                                                docIDs[index]);
                                                            setState(() =>
                                                                Navigator.pop(
                                                                    context));
                                                          },
                                                          child: const Text(
                                                            'Izbriši',
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          )),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const Icon(
                                              Icons.delete_forever,
                                              size: 20)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  })),
        ],
      ),
    );
  }
}
