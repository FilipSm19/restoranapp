import 'package:RestoranApp/circledisplay.dart';
import 'package:RestoranApp/menu/menudisplay.dart';
import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';

import 'drawers/user_drawer.dart';

class Home extends StatefulWidget {
  final int selectedPage;
  const Home(this.selectedPage, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: widget.selectedPage,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Restoran'),
            centerTitle: true,
            titleTextStyle: const TextStyle(
              fontSize: 28,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          drawer: const UserDrawer(),
          body: Column(children: [
            const Material(
                color: Color.fromARGB(255, 59, 141, 35),
                child: TabBar(indicatorColor: Colors.white, tabs: [
                  Tab(
                    child: Icon(Icons.home),
                  ),
                  Tab(
                    child: Icon(Icons.menu_book_rounded),
                  )
                ])),
            Expanded(
              child: TabBarView(children: [
                Scaffold(
                  body: const CircleDisplay(),
                  floatingActionButton: FloatingActionButton.extended(
                    label: const Text(
                      'Rezervirajte',
                    ),
                    onPressed: () async {
                      Uri phone = Uri.parse('tel:123123123123');
                      if (await canLaunchUrl(phone)) {
                        await launchUrl(phone);
                      } else {
                        print('unsuccessful call');
                      }
                    },
                    icon: const Icon(Icons.call),
                  ),
                ),
                const MenuDisplay()
              ]),
            )
          ]),
        ));
  }
}
