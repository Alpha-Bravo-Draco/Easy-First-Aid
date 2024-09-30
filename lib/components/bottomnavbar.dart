import 'package:easy_first_aid/screens/ai_assistant.dart';
import 'package:easy_first_aid/screens/emergencynumbers.dart';
import 'package:easy_first_aid/screens/homescreen.dart';
import 'package:easy_first_aid/screens/symptomscheck.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap; // Callback to handle item tap

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap, // Callback to handle item tap
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.call),
          label: 'Call',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_rounded),
          label: 'Easy AI',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.edit_road_sharp),
        //   label: 'Messages',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_information),
          label: 'Symptoms Checker',
        ),
      ],
      currentIndex: widget.currentIndex,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.grey,
      iconSize: 30.0, // Adjust icon size
      selectedFontSize: 12.0, // Adjust label font size
      unselectedFontSize: 12.0, // Adjust label font size
      onTap: (index) {
        widget.onTap(index);
        // Navigate to a specific screen based on the tapped index
        if (index == 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Homescreen()));
        }
        if (index == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Emergencynumbers(
                        previousIndex: widget.currentIndex,
                      )));
        }
        if (index == 2) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GeminiApp()));
        }
        // if (index == 3) {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => const Trips()));
        // }
        if (index == 3) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Symptomscheck()));
        }
        // Add navigation for other indices if needed
      },
    );
  }
}
