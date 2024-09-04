import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:easy_first_aid/components/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiApp extends StatefulWidget {
  const GeminiApp({super.key});

  @override
  State<GeminiApp> createState() => _GeminiAppState();
}

class _GeminiAppState extends State<GeminiApp> {
  int _selectedIndex = 2;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy AI'),
        centerTitle: true,
      ),
      body: _buildUI(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildUI() {
    return DashChat(
        currentUser: currentUser, onSend: _sendMessage, messages: messages);
  }

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
