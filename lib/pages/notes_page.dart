import 'package:flutter/material.dart';

import '../core/locator.dart';
import '../services/notes_store.dart';
import '../services/text_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _controller = TextEditingController();
  final NotesStore _store = getIt<NotesStore>();
  final TextService _textService = getIt<TextService>();

  int? _editingIndex;
  bool _loading = false;

  void _saveNote() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (_editingIndex == null) {
      _store.add(text);
    } else {
      _store.update(_editingIndex!, text);
    }

    setState(() {
      _editingIndex = null;
      _controller.clear();
    });
  }

  void _editNote(int index) {
    setState(() {
      _controller.text = _store.notes[index];
      _editingIndex = index;
    });
  }

  void _deleteNote(int index) {
    _store.remove(index);
    setState(() {
      _controller.clear();
      _editingIndex = null;
    });
  }

  void _cancelEdit() {
    setState(() {
      _controller.clear();
      _editingIndex = null;
    });
  }

  Future<void> _appendFromNetwork(Future<String> Function() loader) async {
    setState(() => _loading = true);
    try {
      final text = await loader();
      if (!mounted) return;
      setState(() {
        final current = _controller.text.trim();
        _controller.text = current.isEmpty ? text : '$current\n$text';
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Введите текст заметки',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _saveNote,
                  child: Text(_editingIndex == null ? 'Сохранить' : 'Изменить'),
                ),
                if (_editingIndex != null)
                  OutlinedButton(
                    onPressed: _cancelEdit,
                    child: const Text('Отмена'),
                  ),
                OutlinedButton.icon(
                  onPressed: _loading
                      ? null
                      : () => _appendFromNetwork(_textService.randomFact),
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('Добавить факт'),
                ),
                OutlinedButton.icon(
                  onPressed: _loading
                      ? null
                      : () => _appendFromNetwork(_textService.randomJoke),
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  label: const Text('Добавить шутку'),
                ),
              ],
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: ListenableBuilder(
                listenable: _store,
                builder: (context, _) {
                  final notes = _store.notes;
                  if (notes.isEmpty) {
                    return const Center(child: Text('Заметок пока нет'));
                  }
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            ListTile(title: Text(notes[index])),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () => _editNote(index),
                                  child: const Text('Редактировать'),
                                ),
                                TextButton(
                                  onPressed: () => _deleteNote(index),
                                  child: const Text('Удалить'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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