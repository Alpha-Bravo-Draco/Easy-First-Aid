import 'package:flutter_gemini/flutter_gemini.dart'; // Import Gemini SDK for AI interactions.
import 'package:get/get.dart'; // Import GetX package for state management.
import 'package:dash_chat_2/dash_chat_2.dart'; // Import DashChat package for chat functionality.

class GeminiChatController extends GetxController {
  final Gemini gemini = Gemini.instance; // Create an instance of the Gemini AI.
  var messages = <ChatMessage>[].obs; // Observable list of chat messages.

  ChatUser currentUser = ChatUser(
      id: '0', firstName: 'noman', lastName: 'butt'); // Current user details.
  ChatUser geminiUser = ChatUser(
      id: '1', firstName: 'Easy', lastName: 'AI'); // Gemini AI user details.

  // List of health-related keywords for filtering valid questions.
  final List<String> healthKeywords = [
    // General Health
    "health", "wellness", "fitness", "nutrition", "diet", "hygiene", "exercise",
    "mental health", "stress", "hydration", "vitamins", "immunity",
    // First Aid
    "first aid", "CPR", "resuscitation", "breathing", "emergency", "wound care",
    "triage", "survival", "life support",
    // Injuries and Wounds
    "injury", "wound", "bleeding", "fracture", "sprain", "strain", "bruise",
    "burn", "cut", "laceration", "puncture", "broken bone", "dislocation",
    "abrasion", "pain", "hurt",
    // Medical Conditions
    "asthma", "allergy", "anaphylaxis", "diabetes", "hypertension", "stroke",
    "heart attack", "seizure", "shock", "unconscious", "fainting", "choking",
    "concussion", "hypothermia", "heatstroke", "dehydration", "hyperthermia",
    "poisoning", "overdose", "infection",
    // Specific Body Parts
    "head injury", "eye injury", "back injury", "chest pain", "abdominal pain",
    "leg injury", "arm injury", "foot injury", "hand injury",
    // Treatment Methods
    "bandage", "splint", "tourniquet", "ice pack", "defibrillator",
    "pain relief", "antiseptic", "dressing", "compress", "stitches", "ointment",
    "splinting", "immobilization", "gauze", "disinfectant",
    // Common Illnesses
    "fever", "cold", "flu", "cough", "headache", "stomach ache", "dizziness",
    "nausea", "vomiting", "diarrhea", "ear infection", "sore throat",
    // Respiratory Issues
    "shortness of breath", "asthma attack", "breathing difficulties",
    "hyperventilation", "airway obstruction", "respiratory distress",
    // Cardiac Emergencies
    "cardiac arrest", "heart failure", "arrhythmia", "palpitations",
    "chest compression", "defibrillation", "angina", "coronary artery disease",
    // Other Emergencies
    "drowning", "electric shock", "chemical burn", "toxic exposure", "bite",
    "sting", "snakebite", "spider bite", "allergic reaction", "food poisoning"
  ];

  // Method to check if a question is health-related.
  bool isHealthRelated(String question) {
    return healthKeywords.any(
        (keyword) => question.toLowerCase().contains(keyword.toLowerCase()));
  }

  // Method to handle sending messages.
  void sendMessage(ChatMessage chatMessage) {
    messages.insert(0, chatMessage); // Add the user's message to the chat.
    String question = chatMessage.text;

    // Check if the message is related to health or first aid.
    if (isHealthRelated(question)) {
      // If valid, use Gemini to generate AI content for the question.
      gemini.streamGenerateContent(question).listen((event) {
        String response = event.content?.parts?.fold(
                " ", (previous, current) => '$previous ${current.text}') ??
            " "; // Process the AI's response.

        addGeminiMessage(response); // Add the AI's response to the chat.
      });
    } else {
      // If the message is not health-related, send a warning message.
      addGeminiMessage(
          "Please ask only health or first-aid-related questions. Thanks!");
    }
  }

  // Method to add Gemini AI's response to the chat.
  void addGeminiMessage(String response) {
    ChatMessage message = ChatMessage(
      user: geminiUser, // Message is from the AI.
      createdAt: DateTime.now(), // Current timestamp.
      text: response, // AI's response text.
    );
    messages.insert(0, message); // Add the AI's message to the chat.
  }
}
