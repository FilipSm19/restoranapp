import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'konobartable.dart';

class KonobarOrders extends StatefulWidget {
  const KonobarOrders({super.key});

  @override
  State<KonobarOrders> createState() => _KonobarOrdersState();
}

class _KonobarOrdersState extends State<KonobarOrders> {
  refresh() {
    if (mounted) {
      Future.delayed(const Duration(seconds: 1), () => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Center(
              child: Text('Stolovi',
                  style: GoogleFonts.robotoSlab(
                      fontSize: 28, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: GridView.builder(
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              Color tableColor = const Color.fromARGB(255, 57, 158, 27);
              var count = index + 1;
              return FutureBuilder<bool>(
                  future: docExists('$count'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade400),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KonobarTable('$count',
                                        notifyParent: refresh)));
                          },
                          child: const Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.table_bar,
                                size: 90,
                              ),
                              Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey,
                                    ),
                                    color: Colors.grey,
                                    backgroundColor: Colors.white),
                              )
                            ],
                          ));
                    }
                    if (snapshot.data == true) {
                      tableColor = Colors.red.shade700;
                    }
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: tableColor),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KonobarTable('$count',
                                      notifyParent: refresh)));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.table_bar,
                              size: 90,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 26),
                              child: Text(
                                '$count',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(
                                        color: tableColor,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ));
                  });
            }),
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 80,
              crossAxisSpacing: 30,
              mainAxisSpacing: 10,
            ),
          ),
        ),
      ],
    );
  }
}
