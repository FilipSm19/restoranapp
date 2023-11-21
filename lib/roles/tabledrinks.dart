import 'dart:async';
import 'package:RestoranApp/roles/konobartable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TableDrinks extends StatefulWidget {
  final String name;
  final CollectionReference tableCollection;
  final CollectionReference orderCollection;
  final List<String> selecteditemsDrinks;
  final StreamController<List<String>> _selecteditemsDrinks;
  final Stream<List<String>> selectedItemsDrinksStream;
  final TextEditingController _searchTextController;
  final Function notifyParent;
  const TableDrinks(
      this.name,
      this.tableCollection,
      this.orderCollection,
      this.selecteditemsDrinks,
      this._selecteditemsDrinks,
      this.selectedItemsDrinksStream,
      this._searchTextController,
      this.notifyParent,
      {super.key});

  @override
  State<TableDrinks> createState() => _TableDrinksState();
}

class _TableDrinksState extends State<TableDrinks> {
  late String name;
  late CollectionReference tableCollection;
  late CollectionReference orderCollection;
  late List<String> selecteditemsDrinks;
  late StreamController<List<String>> _selecteditemsDrinks;
  late Stream<List<String>> selectedItemsDrinksStream;
  late TextEditingController _searchTextController;
  late Function notifyParent;

  @override
  void initState() {
    name = widget.name;
    tableCollection = widget.tableCollection;
    orderCollection = widget.orderCollection;
    selecteditemsDrinks = widget.selecteditemsDrinks;
    _selecteditemsDrinks = widget._selecteditemsDrinks;
    selectedItemsDrinksStream = widget.selectedItemsDrinksStream;
    _searchTextController = widget._searchTextController;
    notifyParent = widget.notifyParent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: StreamBuilder<DocumentSnapshot>(
              stream: tableCollection.doc(name).snapshots(),
              builder: (context, docSnap) {
                if (docSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return StreamBuilder<QuerySnapshot>(
                  stream: orderCollection.orderBy('name').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty &&
                        (!docSnap.data!.exists)) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Stol je ',
                                  style: GoogleFonts.robotoSlab(
                                      fontSize: 24, color: Colors.black)),
                              TextSpan(
                                  text: 'slobodan,\n',
                                  style: GoogleFonts.robotoSlab(
                                      fontSize: 24,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'trenutno nema narudžbi',
                                  style: GoogleFonts.robotoSlab(
                                      fontSize: 24, color: Colors.black))
                            ],
                          ),
                        ),
                      ));
                    } else if ((snapshot.data!.docs.isEmpty &&
                        docSnap.data!.exists)) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Stol je ',
                                  style: GoogleFonts.robotoSlab(
                                      fontSize: 24, color: Colors.black)),
                              TextSpan(
                                  text: 'zauzet ',
                                  style: GoogleFonts.robotoSlab(
                                      fontSize: 24,
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'ili rezerviran,\ntrenutno nema naručenog pića',
                                  style: GoogleFonts.robotoSlab(
                                      fontSize: 24, color: Colors.black))
                            ],
                          ),
                        ),
                      ));
                    } else {
                      List<QueryDocumentSnapshot<Object?>> orderList =
                          snapshot.data!.docs;

                      return StreamBuilder<List<String>>(
                          initialData: const [],
                          stream: selectedItemsDrinksStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> snapshots) {
                            selecteditemsDrinks =
                                snapshots.data?.toList() ?? [];
                            return ListView.builder(
                                padding: const EdgeInsets.only(
                                    bottom: kFloatingActionButtonMargin + 48),
                                shrinkWrap: true,
                                key: UniqueKey(),
                                itemCount: orderList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      CheckboxListTile(
                                          value: selecteditemsDrinks
                                              .contains(orderList[index].id),
                                          title: Text(
                                            orderList[index]['name'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                          subtitle: Text(
                                              'količina: ${orderList[index]['count']}'),
                                          onChanged: (isChecked) {
                                            if (isChecked == true) {
                                              selecteditemsDrinks
                                                  .add(orderList[index].id);
                                              _selecteditemsDrinks.sink
                                                  .add((selecteditemsDrinks));
                                            } else {
                                              selecteditemsDrinks
                                                  .remove(orderList[index].id);
                                              _selecteditemsDrinks.sink
                                                  .add((selecteditemsDrinks));
                                            }
                                          }),
                                      const Divider()
                                    ],
                                  );
                                });
                          });
                    }
                  },
                );
              }),
        ),
        floatingActionButton: StreamBuilder<List<String>>(
            initialData: const [],
            stream: selectedItemsDrinksStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshots) {
              return Row(
                children: [
                  Visibility(
                    visible:
                        ((snapshots.data!.isNotEmpty) && (snapshots.hasData)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.red,
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            onPressed: () {
                              snapshots.data!.forEach((element) {
                                orderCollection.doc(element).delete();
                                selecteditemsDrinks.remove(element);
                                _selecteditemsDrinks.sink
                                    .add(selecteditemsDrinks);
                              });
                            },
                            label: const Icon(
                              Icons.delete_forever,
                              size: 40,
                            ),
                          )),
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible:
                        ((snapshots.data!.isNotEmpty) && (snapshots.hasData)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                          width: 70,
                          height: 70,
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.lightBlue,
                            shape: const CircleBorder(),
                            onPressed: () {
                              snapshots.data!.forEach((element) {
                                orderCollection.doc(element).get().then((doc) {
                                  if (doc['count'] > 1) {
                                    doc.reference.update(
                                        {"count": FieldValue.increment(-1)});
                                  } else {
                                    doc.reference.delete();
                                    selecteditemsDrinks.remove(element);
                                    _selecteditemsDrinks.sink
                                        .add(selecteditemsDrinks);
                                  }
                                });
                              });
                            },
                            label: const Icon(Icons.remove, size: 30),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: FloatingActionButton.extended(
                        backgroundColor: Colors.lightBlue,
                        shape: const CircleBorder(),
                        onPressed: () {
                          if ((snapshots.data!.isNotEmpty) &&
                              (snapshots.hasData)) {
                            snapshots.data!.forEach((element) {
                              orderCollection.doc(element).get().then((doc) {
                                doc.reference
                                    .update({"count": FieldValue.increment(1)});
                              });
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  List<String> addItems = [];
                                  return AlertDialog(
                                      title: const Text('Unesite narudžbu: '),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            DropdownSearch<
                                                String>.multiSelection(
                                              popupProps: PopupPropsMultiSelection
                                                  .dialog(
                                                      searchDelay:
                                                          const Duration(
                                                              milliseconds:
                                                                  100),
                                                      searchFieldProps:
                                                          TextFieldProps(
                                                              autocorrect: true,
                                                              controller:
                                                                  _searchTextController,
                                                              decoration:
                                                                  InputDecoration(
                                                                      prefixIcon:
                                                                          const Icon(Icons
                                                                              .search),
                                                                      suffixIcon:
                                                                          IconButton(
                                                                        icon: const Icon(
                                                                            Icons.clear),
                                                                        onPressed:
                                                                            () =>
                                                                                {
                                                                          _searchTextController
                                                                              .clear()
                                                                        },
                                                                      ),
                                                                      labelText:
                                                                          'Traži piće')),
                                                      showSearchBox: true,
                                                      showSelectedItems: true),
                                              asyncItems: (context) =>
                                                  getDrinks(),
                                              dropdownDecoratorProps:
                                                  const DropDownDecoratorProps(
                                                      dropdownSearchDecoration:
                                                          InputDecoration(
                                                              labelText:
                                                                  "Odaberite piće",
                                                              hintText:
                                                                  "Odaberite piće")),
                                              onChanged: (value) {
                                                addItems = value;
                                                _searchTextController.clear();
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12, left: 28.0),
                                              child: Row(
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        await docCreate(name);
                                                        addItems.forEach(
                                                            (item) async {
                                                          if (await drinksExists(
                                                              item, name)) {
                                                            tableCollection
                                                                .doc(name)
                                                                .collection(
                                                                    'drinks')
                                                                .where('name',
                                                                    isEqualTo:
                                                                        item)
                                                                .limit(1)
                                                                .get()
                                                                .then((doc) =>
                                                                    doc.docs
                                                                        .forEach(
                                                                            (doc) {
                                                                      doc.reference
                                                                          .update({
                                                                        "count":
                                                                            FieldValue.increment(1)
                                                                      });
                                                                    }));
                                                          } else {
                                                            await orderCollection
                                                                .doc()
                                                                .set({
                                                              "name": item,
                                                              "count": 1
                                                            });
                                                          }
                                                        });

                                                        if (context.mounted) {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                          notifyParent();
                                                        }
                                                      },
                                                      child: const Text('OK')),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 18.0),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                        child: const Text(
                                                            'Odustani')),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ));
                                });
                          }
                        },
                        label: const Icon(
                          Icons.add,
                          size: 30,
                        )),
                  ),
                ],
              );
            }));
  }
}
