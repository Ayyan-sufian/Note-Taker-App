import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:note_taker_app/models/notes_model.dart';
import 'package:uuid/uuid.dart';

class NotesProvider extends ChangeNotifier{
  final Box<NotesModel> _notesBox = Hive.box<NotesModel>('notesBox');


  List<NotesModel> get notes => _notesBox.values.toList(); // Create a list of notes



  /// We can add Notes into our notes list
  void addNotes(String title, String content) {
    final note = NotesModel(
      id: Random().nextInt(100000).toString(), // It generate  random value and assign unique id
      title: title.trim(),
      content: content.trim(),
    );
    _notesBox.put(note.id, note);
    notifyListeners();
  }

  /// We can update Notes
  void updateNote(String id, String title, String content) {
    final note = _notesBox.get(id);
    if (note == null) return;
    note.title = title.trim();
    note.content = content.trim();
    note.save();
    notifyListeners();
  }

  /// We can delete the notes from here
  void deleteNotes(String id) {
    _notesBox.delete(id);
    notifyListeners();
  }

  /// This is use to view a note
  NotesModel? getNotesById(String id) {
   return _notesBox.get(id);
  }
}