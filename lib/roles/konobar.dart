import "package:RestoranApp/menu/menudisplay.dart";
import "package:RestoranApp/roles/konobarorders.dart";
import "package:flutter/material.dart";

import "../circledisplay.dart";
import "../drawers/konobar_drawer.dart";
import "konobarhistory.dart";

class KonobarPage extends StatefulWidget {
  const KonobarPage(this.selectedPage, {super.key});
  final int selectedPage;

  @override
  State<KonobarPage> createState() => _KonobarPageState(selectedPage);
}

class _KonobarPageState extends State<KonobarPage> {
  int selectedPage;
  _KonobarPageState(this.selectedPage);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            initialIndex: selectedPage,
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Restoran'),
                centerTitle: true,
                titleTextStyle: const TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              drawer: KonobarDrawer(),
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
                      )),
                      Tab(
                          child: Icon(
                        Icons.done_all,
                      ))
                    ])),
                Expanded(
                  child: TabBarView(children: [
                    CircleDisplay(),
                    MenuDisplay(),
                    KonobarOrders(),
                    KonobarHistory(),
                  ]),
                )
              ]),
            )));
  }
}
