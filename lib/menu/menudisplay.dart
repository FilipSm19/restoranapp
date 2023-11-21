import "package:RestoranApp/menu/drinks.dart";
import "package:RestoranApp/menu/food.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class MenuDisplay extends StatelessWidget {
  const MenuDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Meni',
                style: GoogleFonts.robotoSlab(
                  textStyle: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 57, 158, 27)),
                  shadows: const [
                    Shadow(
                        color: Colors.black,
                        offset: Offset(0.5, 1),
                        blurRadius: 2),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 120,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          minimumSize: const Size(140, 160)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Foods()));
                      },
                      child: const Column(
                        children: [
                          Icon(
                            Icons.food_bank,
                            size: 100,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Hrana',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          minimumSize: const Size(140, 160)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Drinks()));
                      },
                      child: const Column(
                        children: [
                          Icon(
                            Icons.wine_bar,
                            size: 100,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Piće',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
