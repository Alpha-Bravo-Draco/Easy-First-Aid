import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
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
          const Row(
            children: [
              Images(
                  text: "HOHOH",
                  image:
                      "https://static.vecteezy.com/system/resources/previews/004/899/869/non_2x/boy-rubs-his-face-with-his-hand-conjunctivitis-in-child-inflammation-and-injury-of-eye-tearfulness-symptom-of-eye-disease-vector.jpg"),
              Images(
                  text: "hahaah",
                  image:
                      "https://thumbs.dreamstime.com/b/young-man-bleeding-wounded-hand-simple-style-icon-flat-vector-illustration-isolated-white-background-colorful-129278636.jpg"),
              Images(
                  text: "huihui",
                  image:
                      "https://static.vecteezy.com/system/resources/previews/004/899/869/non_2x/boy-rubs-his-face-with-his-hand-conjunctivitis-in-child-inflammation-and-injury-of-eye-tearfulness-symptom-of-eye-disease-vector.jpg"),
            ],
          ),
        ],
      ),
    );
  }
}

class Images extends StatefulWidget {
  final String text, image;
  final VoidCallback? onPress;

  const Images({
    super.key,
    required this.text,
    required this.image,
    this.onPress,
  });

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: InkWell(
        onTap: widget.onPress,
        child: AspectRatio(
          aspectRatio: 1, // Adjust this to your preferred aspect ratio
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.image,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // color: Colors.black54, // Semi-transparent background for text
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
    );
  }
}
