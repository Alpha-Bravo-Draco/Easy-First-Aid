import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:easy_first_aid/components/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class GeminiApp extends StatefulWidget {
  const GeminiApp({super.key});

  @override
  State<GeminiApp> createState() => _GeminiAppState();
}

class _GeminiAppState extends State<GeminiApp> {
  int _selectedIndex = 2;
  bool _showChatUI = false; // State to track whether chat UI should appear
  final GlobalKey _aiKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeFunction();
  }

  Future<void> _initializeFunction() async {
    print("Initializing the app...");
    await _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    print("Checking if user is a first-time user...");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstTime = prefs.getBool('isFirstTimeShowcase');

    // Null safety: If the value is not present, assume it's the first time
    if (isFirstTime == null || isFirstTime == true) {
      print("First time user. Showing showcase...");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            ShowCaseWidget.of(context).startShowCase([_aiKey]);
          }
        });
      });

      // Ensure `SharedPreferences` is updated correctly
      await prefs.setBool('isFirstTimeShowcase', false);
      print("SharedPreferences updated: First time flag set to false.");
    } else {
      print("User has already seen the showcase.");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];

  ChatUser currentUser =
      ChatUser(id: '0', firstName: 'noman', lastName: 'butt');
  ChatUser geminiUser = ChatUser(id: '1', firstName: 'Easy', lastName: 'AI');

  @override
  Widget build(BuildContext context) {
    print("App is building...");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy AI'),
        centerTitle: true,
      ),
      body: _showChatUI || messages.isNotEmpty
          ? _buildChatUI()
          : _buildAnimatedContainers(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildAnimatedContainers() {
    return Showcase(
      description: "Click on any button to chat with Easy AI",
      key: _aiKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedContainer(
                Colors.red, "How to maintain a\n      healthy diet"),
            SizedBox(height: 20),
            _buildAnimatedContainer(Colors.green, "How can I stay Fit"),
            SizedBox(height: 20),
            _buildAnimatedContainer(Colors.blue, "ask a question"),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(Color color, String text) {
    return GestureDetector(
      onTap: () {
        _sendMessageFromContainer(
            text); // Send the container's text as a message
        setState(() {
          _showChatUI = true; // Show chat UI when container is tapped
        });
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  // Method to send a message when the container is clicked
  void _sendMessageFromContainer(String text) {
    if (text.toLowerCase() == 'ask a question') {
      // Do nothing if the text is 'Ask a question'
      return;
    }

    // Otherwise, proceed to send the message
    ChatMessage chatMessage = ChatMessage(
      user: currentUser,
      text: text,
      createdAt: DateTime.now(),
    );

    _sendMessage(chatMessage);
  }

  // Method to handle message sending to the AI
  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  " ", (previous, current) => '$previous ${current.text}') ??
              " ";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  " ", (previous, current) => '$previous ${current.text}') ??
              " ";
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print("Error-------------------${e.toString()}");
    }
  }
}
