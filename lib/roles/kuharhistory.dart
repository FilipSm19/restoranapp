import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KuharHistory extends StatelessWidget {
  const KuharHistory({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference tableCollection =
        FirebaseFirestore.instance.collection('tables');
    return Scaffold(
        appBar: AppBar(title: const Text('Povijest gotovih jela')),
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

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                        key: UniqueKey(),
                        itemCount: snapshots.data!.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                              stream: tableCollection
                                  .doc(snapshots.data![index])
                                  .collection('food')
                                  .orderBy('name')
                                  .where('finished', isEqualTo: true)
                                  .snapshots()
                                  .map((snapshot) {
                                List<QueryDocumentSnapshot> documentNames = [];
                                snapshot.docs.forEach((doc) {
                                  documentNames.add(doc);
                                });
                                return documentNames;
                              }),
                              builder: ((context, docsnap) {
                                if (docsnap.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.only(left: 40, top: 12),
                                    child: Text('...',
                                        style: TextStyle(fontSize: 20)),
                                  );
                                } else if (docsnap.hasData &&
                                    docsnap.data!.isNotEmpty) {
                                  double height =
                                      docsnap.data!.length.toDouble() + 1;
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5.0),
                                    child: ListTile(
                                      title: SizedBox(
                                        height: 35,
                                        child: Text(
                                          'Narudžba za stol ${orders[index]}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      subtitle: SizedBox(
                                        height: 21 * height,
                                        child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: docsnap.data!.length,
                                            itemBuilder: (context, i) {
                                              return Row(
                                                children: [
                                                  Text(
                                                      '${docsnap.data![i]['count']}x',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14)),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      '${docsnap.data![i]['name']}',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }));
                        }),
                  );
                }
              },
            ),
          ),
        ));
  }
}
