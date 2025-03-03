import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:geminishop/chatbot/message.dart';
import 'package:geminishop/chatbot/messages.dart';
import 'package:geminishop/chatbot/size.dart';
import 'package:geminishop/chatbot/style.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _userMessage = TextEditingController();
  bool isLoading = false;
  static const apiKey = "API-KEY";
  final List<Message> _messages = [];
  final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);

  void sendMessage() async {
    final userMessage = _userMessage.text;
    _userMessage.clear();

    setState(() {
      _messages.add(Message(
        isUser: true,
        message: userMessage,
        date: DateTime.now(),
      ));
      isLoading = true;
    });

    final prompt =
        "You are Feminee, a chatbot helping marginalized women with skill-based training, digital literacy, and support. Be warm, encouraging, and resourceful. User asks: $userMessage";

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      print("API Response: ${response.text}");

      setState(() {
        _messages.add(Message(
          isUser: false,
          message: response.text ??
              "I’m here to help. Could you rephrase your question?",
          date: DateTime.now(),
        ));
        isLoading = false;
      });
    } catch (e, stackTrace) {
      print("❌ ERROR: $e");
      print("🔍 Stack Trace: $stackTrace");

      setState(() {
        _messages.add(Message(
          isUser: false,
          message: "Sorry, something went wrong. Please try again later.",
          date: DateTime.now(),
        ));
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Chat with Feminee',
          style: GoogleFonts.poppins(
              color: resChat, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Messages(
                  isUser: message.isUser,
                  message: message.message,
                  date: DateFormat('HH:mm').format(message.date),
                  onAnimatedTextFinished: () {}, // Pass an empty function
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _userMessage,
                        maxLines: 6,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    if (!isLoading && _userMessage.text.isNotEmpty) {
                      sendMessage();
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: _userMessage.text.isNotEmpty
                        ? resChat
                        : Colors.grey.shade400,
                    radius: 25,
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          )
                        : Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
