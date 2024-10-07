import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login/loggedIn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Restoran App',
        theme: ThemeData(
            tabBarTheme: TabBarTheme(
                labelColor: Colors.white, unselectedLabelColor: Colors.white70),
            progressIndicatorTheme: ProgressIndicatorThemeData(
                color: Colors.lightGreen,
                circularTrackColor: Colors.lightGreen.shade200,
                refreshBackgroundColor: Colors.lightGreen.shade200),
            drawerTheme: const DrawerThemeData(
                backgroundColor: Color.fromARGB(255, 248, 252, 218)),
            scaffoldBackgroundColor: const Color.fromARGB(255, 248, 252, 218),
            appBarTheme: const AppBarTheme(
                foregroundColor: Colors.white,
                color: Color.fromARGB(255, 40, 110, 19)),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 48, 133, 23)),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 48, 133, 23))),
            buttonTheme: const ButtonThemeData(
              alignedDropdown: true,
            )),
        home: const LoggedIn());
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  const ResponsivePadding({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).size.width > 650
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3.8)
          : const EdgeInsets.all(0),
      child: child,
    );
  }
}
