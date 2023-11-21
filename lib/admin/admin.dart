import 'package:RestoranApp/admin/admin_editusers.dart';
import 'package:RestoranApp/circledisplay.dart';
import 'package:RestoranApp/menu/menudisplay.dart';
import 'package:RestoranApp/roles/konobarorders.dart';
import 'package:RestoranApp/roles/kuharorders.dart';
import "package:flutter/material.dart";
import '../drawers/admin_drawer.dart';
import 'admin_adduser.dart';

class AdminPage extends StatefulWidget {
  final int selectedPage;
  const AdminPage(this.selectedPage, {super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late int selectedPage;
  @override
  void initState() {
    selectedPage = widget.selectedPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            initialIndex: selectedPage,
            length: 5,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Restoran'),
                centerTitle: true,
                titleTextStyle: const TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              drawer: AdminDrawer(),
              body: Column(children: [
                const Material(
                    color: Color.fromARGB(255, 59, 141, 35),
                    child: TabBar(indicatorColor: Colors.white, tabs: [
                      Tab(
                        child: Icon(Icons.home),
                      ),
                      Tab(
                        child: Icon(Icons.menu_book_rounded),
                      ),
                      Tab(
                        child: Icon(Icons.supervisor_account),
                      ),
                      Tab(
                        child: Icon(Icons.table_bar),
                      ),
                      Tab(
                        child: Icon(Icons.food_bank),
                      )
                    ])),
                Expanded(
                  child: TabBarView(children: [
                    const CircleDisplay(),
                    const MenuDisplay(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 400,
                          child: ListTile(
                            title: ElevatedButton.icon(
                                icon: const Icon(Icons.group_add),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(50, 70)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddUser()));
                                },
                                label: const Text(
                                  'Dodavanje zaposlenika',
                                  style: TextStyle(fontSize: 20),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child: ListTile(
                            title: ElevatedButton.icon(
                                icon: const Icon(Icons.edit),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(50, 60)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EditUsersPage()));
                                },
                                label: const Text('Uređivanje zaposlenika',
                                    style: TextStyle(fontSize: 20))),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Icon(
                            Icons.groups,
                            size: 320,
                            color: Color.fromARGB(69, 158, 240, 111),
                          ),
                        ),
                      ],
                    ),
                    KonobarOrders(),
                    KuharOrders()
                  ]),
                )
              ]),
            )));
  }
}
