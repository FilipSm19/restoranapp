import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircleDisplay extends StatefulWidget {
  const CircleDisplay({super.key});

  @override
  State<CircleDisplay> createState() => _CircleDisplayState();
}

class _CircleDisplayState extends State<CircleDisplay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('tables').snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Column(
                    children: [
                      SizedBox(height: 140),
                      CircularProgressIndicator(),
                    ],
                  );
                } else {
                  final tables = snapshots.data!.docs.length;
                  final double tPercent = ((tables / 10));
                  Color pcolor = Colors.lightGreen.shade600;
                  Color bcolor = Colors.lightGreen.shade200;
                  Color mcolor = Colors.green;
                  Color fcolor = Colors.lightGreen.shade50;
                  Color icolor = Colors.lightGreen.shade600;
                  String message = '';

                  if (tPercent > 0.3 && tPercent < 0.6) {
                    pcolor = const Color.fromARGB(255, 73, 150, 57);
                    bcolor = const Color.fromARGB(255, 197, 225, 165);
                    mcolor = const Color.fromARGB(255, 117, 184, 63);
                    icolor = const Color.fromARGB(255, 131, 190, 82);
                    fcolor = const Color.fromARGB(255, 235, 252, 196);
                    message = 'Trenutno ima slobodnih stolova';
                  } else if (tPercent > 0.5 && tPercent < 1) {
                    pcolor = const Color.fromARGB(255, 247, 204, 13);
                    bcolor = const Color.fromARGB(255, 252, 241, 144);
                    mcolor = const Color.fromARGB(255, 223, 171, 29);
                    icolor = const Color.fromARGB(255, 211, 194, 45);
                    fcolor = const Color.fromARGB(255, 248, 244, 193);
                    message = 'Većina stolova je zauzeto';
                  } else if (tPercent == 1) {
                    pcolor = Colors.orange.shade300;
                    bcolor = Colors.orange.shade200;
                    mcolor = Colors.orange.shade600;
                    icolor = Colors.orange.shade500;
                    fcolor = const Color.fromARGB(255, 255, 244, 207);
                    message = 'Trenutno su zauzeti svi stolovi';
                  } else {
                    pcolor = const Color.fromARGB(255, 60, 148, 63);
                    bcolor = Colors.lightGreen.shade200;
                    mcolor = Colors.lightGreen.shade700;
                    icolor = const Color.fromARGB(255, 66, 161, 69);
                    fcolor = const Color.fromARGB(255, 227, 252, 196);
                    message = 'Trenutno ima slobodnih stolova';
                  }
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: mcolor, blurRadius: 0, spreadRadius: 2),
                            BoxShadow(
                                color: icolor, blurRadius: 6, spreadRadius: 1),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(160),
                          child: CircularPercentIndicator(
                            addAutomaticKeepAlive: true,
                            animateFromLastPercent: true,
                            animationDuration: 600,
                            fillColor: icolor,
                            radius: 160,
                            lineWidth: 20,
                            circularStrokeCap: CircularStrokeCap.round,
                            percent: tPercent,
                            progressColor: bcolor,
                            backgroundColor: pcolor,
                            center: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: fcolor,
                                        blurRadius: 0,
                                        spreadRadius: 98),
                                  ],
                                ),
                                child: Text(message,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(
                                          shadows: const [
                                            Shadow(
                                                color: Colors.black,
                                                offset: Offset(0.5, 1),
                                                blurRadius: 2),
                                          ],
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                          color: mcolor),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('(${10 - tables} slobodnih stolova)',
                          style: GoogleFonts.quicksand(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ))
                    ],
                  );
                }
              }),
        ),
      ],
    );
  }
}
