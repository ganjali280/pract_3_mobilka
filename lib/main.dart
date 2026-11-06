import 'package:flutter/material.dart';

import 'core/locator.dart';
import 'pages/notes_page.dart';

void main() {
  setupLocator();
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage(),
    );
  }
}