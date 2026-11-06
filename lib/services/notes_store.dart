import 'package:flutter/foundation.dart';

class NotesStore extends ChangeNotifier {
  final List<String> _notes = [];

  List<String> get notes => List.unmodifiable(_notes);

  void add(String text) {
    _notes.add(text);
    notifyListeners();
  }

  void update(int index, String text) {
    _notes[index] = text;
    notifyListeners();
  }

  void remove(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }
}