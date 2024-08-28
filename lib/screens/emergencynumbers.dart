import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_first_aid/components/bottomnavbar.dart';

class Emergencynumbers extends StatefulWidget {
  const Emergencynumbers({super.key});

  @override
  State<Emergencynumbers> createState() => _EmergencynumbersState();
}

class _EmergencynumbersState extends State<Emergencynumbers> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              Container(
                height: 70,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 55, 41),
                ),
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Emergency helplines, Tap on the button to make a call',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                height: 10,
              ),
              Images(
                text: "Ambulance (1122)",
                addShadow: true,
                onPress: () => _makePhoneCall('1122'), // Ambulance number
                image:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRl4EY56b8clx7DKbh2yJAAAjqlseW4Hs6aVw&s',
              ),
              Images(
                text: "Police",
                addShadow: true,
                onPress: () => _makePhoneCall('15'), // Police number
                image:
                    'https://static.vecteezy.com/system/resources/previews/025/434/754/non_2x/kids-drawing-illustration-police-car-side-view-flat-cartoon-isolated-vector.jpg',
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Images(
                text: "Edhi Ambulance (1122)",
                addShadow: true,
                onPress: () => _makePhoneCall('115'), // Ambulance number
                image:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRl4EY56b8clx7DKbh2yJAAAjqlseW4Hs6aVw&s',
              ),
              Images(
                text: "chipa Ambulance (1020)",
                addShadow: true,
                onPress: () => _makePhoneCall('15'), // Police number
                image:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRl4EY56b8clx7DKbh2yJAAAjqlseW4Hs6aVw&s',
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Images(
                text: "Fire Brigade",
                addShadow: true,
                onPress: () => _makePhoneCall('16'), // Ambulance number
                image:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpjOZKzXQOfbNnW3EgXQTTSSEl9b_3MK8rGA&ss',
              ),
              Images(
                text: " ",
                addShadow: true,
                onPress: () => _makePhoneCall('1166'), // Police number
                image:
                    'https://static.vecteezy.com/system/resources/previews/009/902/432/non_2x/medical-assistant-icon-illustration-vector.jpg',
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Images extends StatefulWidget {
  final String text, image;
  final VoidCallback? onPress;
  final bool addShadow;

  const Images({
    super.key,
    required this.text,
    required this.image,
    this.onPress,
    this.addShadow = false,
  });

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: InkWell(
          onTap: widget.onPress,
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: widget.addShadow
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.text,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
