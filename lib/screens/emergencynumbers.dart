import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
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
    // Check if the permission is granted
    PermissionStatus status = await Permission.phone.status;

    if (status.isGranted) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: number,
      );
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch $number';
      }
    } else if (status.isDenied) {
      // Request permission if it is denied
      status = await Permission.phone.request();
      if (status.isGranted) {
        // Try making the call again if permission is granted
        _makePhoneCall(number);
      } else {
        // Handle the case where permission is permanently denied
        _showPermissionDeniedDialog();
      }
    } else if (status.isPermanentlyDenied) {
      // Open app settings if permission is permanently denied
      openAppSettings();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
              'Phone call permission is required to make calls. Please enable it in the app settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          const SizedBox(height: 10),
          Row(
            children: [
              Images(
                text: "Ambulance (1122)",
                addShadow: true,
                onPress: () => _makePhoneCall('1122'),
                image:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRl4EY56b8clx7DKbh2yJAAAjqlseW4Hs6aVw&s',
              ),
              Images(
                text: "Police",
                addShadow: true,
                onPress: () => _makePhoneCall('15'),
                image:
                    'https://static.vecteezy.com/system/resources/previews/025/434/754/non_2x/kids-drawing-illustration-police-car-side-view-flat-cartoon-isolated-vector.jpg',
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Images(
                text: "Edhi Ambulance (1122)",
                addShadow: true,
                onPress: () => _makePhoneCall('115'),
                image:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRl4EY56b8clx7DKbh2yJAAAjqlseW4Hs6aVw&s',
              ),
              Images(
                text: "Chhipa Ambulance (1020)",
                addShadow: true,
                onPress: () => _makePhoneCall('1020'),
                image:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRl4EY56b8clx7DKbh2yJAAAjqlseW4Hs6aVw&s',
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Images(
                text: "Fire Brigade",
                addShadow: true,
                onPress: () => _makePhoneCall('16'),
                image:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpjOZKzXQOfbNnW3EgXQTTSSEl9b_3MK8rGA&ss',
              ),
              Images(
                text: "Medical Assistance (1166)",
                addShadow: true,
                onPress: () => _makePhoneCall('1166'),
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
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                              offset: const Offset(0, 3),
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
                          color: Colors.black,
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
