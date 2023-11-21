import 'dart:async';

import 'package:RestoranApp/roles/kuharhistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KuharOrders extends StatefulWidget {
  const KuharOrders({super.key});

  @override
  State<KuharOrders> createState() => _KuharOrdersState();
}

class _KuharOrdersState extends State<KuharOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      const SizedBox(height: 160),
      SizedBox(
        width: 400,
        child: ListTile(
          title: ElevatedButton.icon(
              icon: const Icon(Icons.brunch_dining),
              style: ElevatedButton.styleFrom(minimumSize: const Size(50, 70)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const KuharToMake()));
              },
              label: const Text(
                'Jela za napravit',
                style: TextStyle(fontSize: 20),
              )),
        ),
      ),
      const SizedBox(
        height: 6,
      ),
      SizedBox(
        width: 400,
        child: ListTile(
          title: ElevatedButton.icon(
              icon: const Icon(Icons.history),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(50, 70),
                  backgroundColor: Color.fromARGB(255, 187, 176, 22)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const KuharHistory()));
              },
              label: const Text('Povijest gotovih jela',
                  style: TextStyle(fontSize: 20))),
        ),
      ),
    ]));
  }
}

class KuharToMake extends StatefulWidget {
  const KuharToMake({super.key});

  @override
  State<KuharToMake> createState() => _KuharToMakeState();
}

class _KuharToMakeState extends State<KuharToMake> {
  List<String> selectedOrder = [];
  final StreamController<List<String>> _selectedOrder =
      StreamController<List<String>>.broadcast();
  Stream<List<String>> get selectedOrderStream => _selectedOrder.stream;
  @override
  void dispose() {
    _selectedOrder.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedOrder.sink.add([]);
  }

  @override
  void didUpdateWidget(KonobarTable) {
    super.didUpdateWidget(KonobarTable);
    _selectedOrder.sink.add([]);
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference tableCollection =
        FirebaseFirestore.instance.collection('tables');
    return Scaffold(
        appBar: AppBar(title: const Text('Jela za napravit')),
        body: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(4),
            child: StreamBuilder<List<String>>(
              stream: tableCollection.snapshots().map((snapshot) {
                List<String> documentNames = [];
                snapshot.docs.forEach((doc) {
                  documentNames.add(doc.id);
                });
                return documentNames;
              }),
              builder: (BuildContext context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<String>? orders = snapshots.data;
                  orders!.sort((a, b) => a.length.compareTo(b.length));
                  return StreamBuilder<List<String>>(
                      initialData: [],
                      stream: selectedOrderStream,
                      builder: (context, ordersSnap) {
                        selectedOrder = ordersSnap.data?.toList() ?? [];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              key: UniqueKey(),
                              itemCount: snapshots.data!.length,
                              itemBuilder: (context, index) {
                                return StreamBuilder(
                                    stream: tableCollection
                                        .doc(snapshots.data![index])
                                        .collection('food')
                                        .orderBy('name')
                                        .where('finished', isEqualTo: false)
                                        .snapshots()
                                        .map((snapshot) {
                                      List<QueryDocumentSnapshot>
                                          documentNames = [];
                                      snapshot.docs.forEach((doc) {
                                        documentNames.add(doc);
                                      });
                                      return documentNames;
                                    }),
                                    builder: ((context, docsnap) {
                                      if (docsnap.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Padding(
                                          padding: EdgeInsets.only(
                                              left: 40, top: 12),
                                          child: Text('...',
                                              style: TextStyle(fontSize: 20)),
                                        );
                                      } else if (docsnap.hasData &&
                                          docsnap.data!.isNotEmpty) {
                                        double height =
                                            docsnap.data!.length.toDouble() + 1;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 5),
                                          child: SingleChildScrollView(
                                            child: CheckboxListTile(
                                              value: selectedOrder
                                                  .contains(orders[index]),
                                              title: SizedBox(
                                                height: 30,
                                                child: Text(
                                                  'Narudžba za stol broj ${orders[index]}',
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                              ),
                                              subtitle: SizedBox(
                                                height: height * 22,
                                                child: ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        docsnap.data!.length,
                                                    itemBuilder: (context, i) {
                                                      return Row(
                                                        children: [
                                                          Text(
                                                              '${docsnap.data![i]['count']}x',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                          Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Text(
                                                                '${docsnap.data![i]['name']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              ),
                                              onChanged: (isChecked) {
                                                if (isChecked == true) {
                                                  selectedOrder
                                                      .add(orders[index]);
                                                  _selectedOrder.sink
                                                      .add((selectedOrder));
                                                } else {
                                                  selectedOrder
                                                      .remove(orders[index]);
                                                  _selectedOrder.sink
                                                      .add((selectedOrder));
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }));
                              }),
                        );
                      });
                }
              },
            ),
          ),
          floatingActionButton: StreamBuilder<List<String>>(
              initialData: [],
              stream: selectedOrderStream,
              builder: (context, snapshots) {
                return Visibility(
                    visible:
                        ((snapshots.data!.isNotEmpty) && (snapshots.hasData)),
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: SizedBox(
                                    width: 320,
                                    height: 300,
                                    child: AlertDialog(
                                        title: const Text(
                                          'Potvrditi gotova jela?',
                                        ),
                                        content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                  onPressed: () async {
                                                    if (context.mounted) {
                                                      selectedOrder.forEach(
                                                          (table) async {
                                                        await tableCollection
                                                            .doc(table)
                                                            .collection('food')
                                                            .get()
                                                            .then((DocSnap) {
                                                          for (DocumentSnapshot snaps
                                                              in DocSnap.docs) {
                                                            snaps.reference
                                                                .update({
                                                              'finished': true
                                                            });
                                                          }
                                                        });
                                                      });
                                                    }
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: const Text(
                                                    'OK',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                              const SizedBox(width: 20),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: const Text('Odustani',
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )))
                                            ])),
                                  ),
                                );
                              });
                        },
                        label: const Icon(
                          Icons.done,
                          size: 30,
                        ),
                      ),
                    ));
              }),
        ));
  }
}
