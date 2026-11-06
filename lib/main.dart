 import 'package:flutter/material.dart';

void main() {
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

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _notes = [];
  int? _editingIndex;

  void _saveNote() {
    if (_controller.text.trim().isEmpty) {
      return;
    }

    setState(() {
      if (_editingIndex == null) {
        _notes.add(_controller.text);
      } else {
        _notes[_editingIndex!] = _controller.text;
        _editingIndex = null;
      }

      _controller.clear();
    });
  }

  void _editNote(int index) {
    setState(() {
      _controller.text = _notes[index];
      _editingIndex = index;
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
      _controller.clear();
      _editingIndex = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заметки')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Введите текст заметки',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text(_editingIndex == null ? 'Сохранить' : 'Изменить'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(title: Text(_notes[index])),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _editNote(index),
                            child: const Text('Редактировать'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _deleteNote(index),
                            child: const Text('Удалить'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}