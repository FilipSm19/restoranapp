import 'dart:async';

import 'package:RestoranApp/roles/tabledrinks.dart';
import 'package:RestoranApp/roles/tablefood.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KonobarTable extends StatefulWidget {
  final Function() notifyParent;
  final String name;
  const KonobarTable(this.name, {Key? key, required this.notifyParent})
      : super(key: key);

  @override
  State<KonobarTable> createState() => _KonobarTableState();
}

Future<List<String>> getDrinks() async {
  QuerySnapshot doc =
      await FirebaseFirestore.instance.collection('drinks').get();
  List<String> data = [];
  for (var element in doc.docs) {
    data.add(element['name']);
  }
  data.sort();
  return data;
}

Future<List<String>> getFood() async {
  QuerySnapshot doc = await FirebaseFirestore.instance.collection('food').get();
  List<String> data = [];
  for (var element in doc.docs) {
    data.add(element['name']);
  }
  data.sort();
  return data;
}

Future<bool> drinksExists(String? item, String name) async {
  QuerySnapshot doc = await FirebaseFirestore.instance
      .collection('tables')
      .doc(name)
      .collection('drinks')
      .where('name', isEqualTo: item)
      .get();
  if (doc.docs.isEmpty) {
    return false;
  } else {
    return true;
  }
}

Future<bool> foodExists(String? item, String name) async {
  QuerySnapshot doc = await FirebaseFirestore.instance
      .collection('tables')
      .doc(name)
      .collection('food')
      .where('name', isEqualTo: item)
      .get();
  if (doc.docs.isEmpty) {
    return false;
  } else {
    return true;
  }
}

Future<bool> docExists(String name) async {
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('tables').doc(name).get();
  if (doc.exists) {
    return true;
  } else {
    return false;
  }
}

Future docCreate(String name) async {
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('tables').doc(name).get();
  if (doc.exists == false) {
    await FirebaseFirestore.instance.collection('tables').doc(name).set({});
  }
}

Future<void> drinksdelete(String name) async {
  var collection = FirebaseFirestore.instance
      .collection('tables')
      .doc(name)
      .collection('drinks');
  var snapshots = await collection.get();
  for (var doc in snapshots.docs) {
    await doc.reference.delete();
  }
}

Future<void> fooddelete(String name) async {
  var collection = FirebaseFirestore.instance
      .collection('tables')
      .doc(name)
      .collection('food');
  var snapshots = await collection.get();
  for (var doc in snapshots.docs) {
    await doc.reference.delete();
  }
}

class _KonobarTableState extends State<KonobarTable> {
  late String name;

  List<String> selecteditemsDrinks = [];
  List<String> selecteditemsFood = [];

  final StreamController<List<String>> _selecteditemsDrinks =
      StreamController<List<String>>.broadcast();

  Stream<List<String>> get selectedItemsDrinksStream =>
      _selecteditemsDrinks.stream;

  final StreamController<List<String>> _selecteditemsFood =
      StreamController<List<String>>.broadcast();

  Stream<List<String>> get selectedItemsFoodStream => _selecteditemsFood.stream;

  IconData? icon;
  String? iconlabel;
  bool isChecked = false;
  final CollectionReference tableCollection =
      FirebaseFirestore.instance.collection('tables');
  final _searchTextController = TextEditingController();

  @override
  void dispose() {
    _searchTextController.dispose();
    _selecteditemsDrinks.close();
    _selecteditemsFood.close();
    super.dispose();
  }

  @override
  void initState() {
    name = widget.name;
    super.initState();
    _selecteditemsDrinks.sink.add([]);
    _selecteditemsFood.sink.add([]);
  }

  @override
  void didUpdateWidget(KonobarTable) {
    super.didUpdateWidget(KonobarTable);
    _selecteditemsDrinks.sink.add([]);
    _selecteditemsFood.sink.add([]);
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference drinksCollection =
        tableCollection.doc(name).collection('drinks');

    final CollectionReference foodCollection =
        tableCollection.doc(name).collection('food');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text('Stol $name'), actions: [
          StreamBuilder(
              stream: tableCollection.doc(name).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 70.0),
                      child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator()),
                    ),
                  );
                }
                if (snapshot.data!.exists) {
                  icon = Icons.delete_sweep_outlined;
                  iconlabel = 'Oslobodi stol';
                } else {
                  icon = Icons.bookmark_add;
                  iconlabel = 'Rezerviraj stol';
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      bool dialog = false;
                      bool exists = await docExists(name);
                      if (context.mounted) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              if (exists == true) {
                                return Center(
                                  child: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: AlertDialog(
                                      title: const Text(
                                        'Osloboditi stol?',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Row(
                                        children: [
                                          TextButton(
                                              onPressed: () async {
                                                dialog = true;
                                                await fooddelete(name);
                                                await drinksdelete(name);
                                                await tableCollection
                                                    .doc(name)
                                                    .delete();
                                                selecteditemsDrinks = [];
                                                selecteditemsFood = [];
                                                _selecteditemsDrinks.sink
                                                    .add(selecteditemsDrinks);
                                                _selecteditemsFood.sink
                                                    .add(selecteditemsFood);

                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                  widget.notifyParent();
                                                }

                                                if (context.mounted) {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    1000), () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        });
                                                        return const Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                      });
                                                }
                                              },
                                              child: const Text(
                                                'OK',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          const Spacer(),
                                          TextButton(
                                              onPressed: () {
                                                dialog = false;
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Odustani',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  )))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: AlertDialog(
                                      title: const Text(
                                        'Rezervirati stol?',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Row(
                                        children: [
                                          TextButton(
                                              onPressed: () async {
                                                await docCreate(name);
                                                if (context.mounted) {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                  widget.notifyParent();
                                                  if (context.mounted) {
                                                    showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (context) {
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      1000),
                                                              () => Navigator.of(
                                                                      context)
                                                                  .pop(true));
                                                          return const Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        });
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          const Spacer(),
                                          TextButton(
                                              onPressed: () {
                                                dialog = false;

                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Odustani',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  )))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            });
                      }
                      if (dialog == true) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            });
                        if (exists) {
                          await fooddelete(name);
                          await drinksdelete(name);
                          tableCollection.doc(name).delete();
                          selecteditemsDrinks = [];
                          selecteditemsFood = [];
                          _selecteditemsDrinks.sink.add(selecteditemsDrinks);
                          _selecteditemsFood.sink.add(selecteditemsFood);
                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        } else {
                          docCreate(name);
                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 37, 87, 17)),
                    icon: Icon(icon),
                    label:
                        Text(iconlabel!, style: const TextStyle(fontSize: 16)),
                  ),
                );
              })
        ]),
        body: Column(
          children: [
            const Material(
                color: Color.fromARGB(255, 59, 141, 35),
                child: TabBar(indicatorColor: Colors.white, tabs: [
                  Tab(
                    child: Icon(Icons.wine_bar, size: 32),
                  ),
                  Tab(
                      child: Icon(
                    Icons.dining_outlined,
                    size: 32,
                  ))
                ])),
            Expanded(
              child: TabBarView(
                children: [
                  TableDrinks(
                      name,
                      tableCollection,
                      drinksCollection,
                      selecteditemsDrinks,
                      _selecteditemsDrinks,
                      selectedItemsDrinksStream,
                      _searchTextController,
                      widget.notifyParent),
                  TableFood(
                      name,
                      tableCollection,
                      foodCollection,
                      selecteditemsFood,
                      _selecteditemsFood,
                      selectedItemsFoodStream,
                      _searchTextController,
                      widget.notifyParent)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
