import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geminishop/chatbot/size.dart';

Color background = const Color.fromARGB(255, 241, 244, 241);
Color userChat = const Color(0xFF1A80E5);
Color resChat = const Color(0xFF243647);
Color chatColor = const Color(0xFF47698A);
var white = const Color(0xFFFFFFFF);
Color hintColor = const Color(0xFF47698A);

TextStyle messageText = GoogleFonts.poppins(color: white, fontSize: small);
TextStyle appBarTitle =
    GoogleFonts.poppins(color: white, fontWeight: FontWeight.bold);
TextStyle hintText = GoogleFonts.poppins(color: resChat, fontSize: small);
TextStyle dateText = GoogleFonts.poppins(color: resChat, fontSize: 13);
TextStyle promptText = GoogleFonts.poppins(color: resChat, fontSize: small);
