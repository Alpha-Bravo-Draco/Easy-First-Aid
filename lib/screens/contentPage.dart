import 'package:easy_first_aid/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentPage extends StatefulWidget {
  final String title;
  final String description;
  final String step1;
  final String step2;
  final String step3;

  final String imageUrl;

  const ContentPage({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.step1,
    required this.step2,
    required this.step3,
  }) : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  Future<void> _makePhoneCall(String number) async {
    // Check if the permission is granted
    PermissionStatus status = await Permission.phone.status;

    if (status.isGranted) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: number,
      );
      if (await canLaunch(launchUri.toString())) {
        await launch(launchUri.toString());
      } else {
        throw 'Could not launch $number';
      }
    } else if (status.isDenied) {
      // Request permission if it is denied
      status = await Permission.phone.request();
      if (status.isGranted) {
        print("Phone permission status: ${status.toString()}");

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

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceIn,
        );
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Homescreen(),
                ),
              );
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.description,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Center(
                    child: Text(
                      'Step ${_currentStep + 1}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    children: [
                      _buildStepContent(widget.step1),
                      _buildStepContent(widget.step2),
                      _buildStepContent(widget.step3),
                    ],
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: double.infinity,
            color: Colors.blueAccent,
            padding: EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                _makePhoneCall('1166');
              },
              child: Center(
                child: Text(
                  'Call for Medical Assistance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(String stepDescription) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepDescription,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavigationButton(Icons.arrow_back, _previousStep),
          _buildNavigationButton(Icons.arrow_forward, _nextStep),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
        padding: EdgeInsets.all(16),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
