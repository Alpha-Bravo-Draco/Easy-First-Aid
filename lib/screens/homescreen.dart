import 'package:easy_first_aid/components/bottomnavbar.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 150, 197, 197),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 70,
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        "Welcome to Easy First Aid",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        'assets/images/FirstAid.png',
                        fit: BoxFit
                            .contain, // Adjusts the image size while maintaining aspect ratio
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 14),
                  child: Text(
                    "Always have your first aid guide in your pocket",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text(
                    "Save lives, be a hero",
                    style: TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 61, 59, 59)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text(
              "Home",
              style: TextStyle(
                  fontSize: 23,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Images(
                  onPress: () {},
                  text: "HOHOH",
                  image:
                      "https://static.vecteezy.com/system/resources/previews/004/899/869/non_2x/boy-rubs-his-face-with-his-hand-conjunctivitis-in-child-inflammation-and-injury-of-eye-tearfulness-symptom-of-eye-disease-vector.jpg"),
              Images(
                  onPress: () {},
                  text: "hahaah",
                  image:
                      "https://thumbs.dreamstime.com/b/young-man-bleeding-wounded-hand-simple-style-icon-flat-vector-illustration-isolated-white-background-colorful-129278636.jpg"),
              Images(
                  onPress: () {},
                  text: "huihui",
                  image:
                      "https://static.vecteezy.com/system/resources/previews/004/899/869/non_2x/boy-rubs-his-face-with-his-hand-conjunctivitis-in-child-inflammation-and-injury-of-eye-tearfulness-symptom-of-eye-disease-vector.jpg"),
            ],
          ),
          Row(
            children: [
              Images(
                  onPress: () {},
                  text: "HOHOH",
                  image:
                      "https://static.vecteezy.com/system/resources/previews/004/899/869/non_2x/boy-rubs-his-face-with-his-hand-conjunctivitis-in-child-inflammation-and-injury-of-eye-tearfulness-symptom-of-eye-disease-vector.jpg"),
              Images(
                  onPress: () {},
                  text: "hahaah",
                  image:
                      "https://thumbs.dreamstime.com/b/young-man-bleeding-wounded-hand-simple-style-icon-flat-vector-illustration-isolated-white-background-colorful-129278636.jpg"),
              Images(
                  onPress: () {},
                  text: "huihui",
                  image:
                      "https://static.vecteezy.com/system/resources/previews/004/899/869/non_2x/boy-rubs-his-face-with-his-hand-conjunctivitis-in-child-inflammation-and-injury-of-eye-tearfulness-symptom-of-eye-disease-vector.jpg"),
            ],
          ),
          Row(
            children: [
              Images(
                  onPress: () {},
                  text: "HOHOH",
                  image:
                      "https://static.vecteezy.com/system/resources/previews/004/899/869/non_2x/boy-rubs-his-face-with-his-hand-conjunctivitis-in-child-inflammation-and-injury-of-eye-tearfulness-symptom-of-eye-disease-vector.jpg"),
              Images(
                  onPress: () {},
                  text: "hahaah",
                  image:
                      "https://thumbs.dreamstime.com/b/young-man-bleeding-wounded-hand-simple-style-icon-flat-vector-illustration-isolated-white-background-colorful-129278636.jpg"),
              Images(
                  onPress: () {},
                  text: "huihui",
                  image:
                      "https://static.vecteezy.com/system/resources/previews/004/899/869/non_2x/boy-rubs-his-face-with-his-hand-conjunctivitis-in-child-inflammation-and-injury-of-eye-tearfulness-symptom-of-eye-disease-vector.jpg"),
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
  final bool addShadow; // New property to control shadow

  const Images({
    super.key,
    required this.text,
    required this.image,
    this.onPress,
    this.addShadow = false, // Default value is false, meaning no shadow
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
        padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 8.0), // Padding added on all sides except top
        child: InkWell(
          onTap: widget.onPress,
          child: AspectRatio(
            aspectRatio: 1, // Adjust this to your preferred aspect ratio
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: widget.addShadow
                        ? [
                            BoxShadow(
                              color: Color.fromARGB(255, 201, 198, 198)
                                  .withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ]
                        : [], // No shadow if addShadow is false
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
