import 'package:RestoranApp/circledisplay.dart';
import 'package:RestoranApp/menu/menudisplay.dart';
import 'package:RestoranApp/roles/kuharorders.dart';
import "package:flutter/material.dart";
import '../drawers/kuhar_drawer.dart';

class KuharPage extends StatefulWidget {
  final int selectedPage;
  KuharPage(this.selectedPage, {super.key});

  @override
  State<KuharPage> createState() => _KuharPageState(selectedPage);
}

class _KuharPageState extends State<KuharPage> {
  int selectedPage;
  _KuharPageState(this.selectedPage);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            initialIndex: selectedPage,
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Restoran'),
                centerTitle: true,
                titleTextStyle: const TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              drawer: KuharDrawer(),
              body: const Column(children: [
                Material(
                    color: Color.fromARGB(255, 59, 141, 35),
                    child: TabBar(indicatorColor: Colors.white, tabs: [
                      Tab(
                        child: Icon(Icons.home),
                      ),
                      Tab(
                        child: Icon(Icons.menu_book_rounded),
                      ),
                      Tab(
                          child: Icon(
                        Icons.list_alt,
                      ))
                    ])),
                Expanded(
                  child: TabBarView(children: [
                    CircleDisplay(),
                    MenuDisplay(),
                    KuharOrders(),
                  ]),
                )
              ]),
            )));
  }
}
