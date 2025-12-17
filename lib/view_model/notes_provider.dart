import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:note_taker_app/models/notes_model.dart';

class NotesProvider extends ChangeNotifier{
  List<NotesModel> _notes = []; // Create a list of notes

  List<NotesModel> get notes => List.unmodifiable(_notes); // use getter here

  /// We can add Notes into our notes list
  void addNotes(String title, String content) {
    final note = NotesModel(
      id: Random().nextInt(1000).toString(), // It generate random value and assign unique id
      title: title,
      content: content,
    );
    _notes.add(note);
    notifyListeners();
  }

  /// We can update Notes
  void updateNote(String id, String title, String content) {
    final index = _notes.indexWhere((notes) => notes.id == id);
    if (index == -1) return;
    _notes[index].title = title;
    _notes[index].content = content;
    notifyListeners();
  }

  /// We can delete the notes from here
  void deleteNotes(String id) {
    _notes.removeWhere((notes) => notes.id == id);
    notifyListeners();
  }

  /// This is use to view a note
  NotesModel? getNotesById(String id) {
    try{
      return _notes.firstWhere((notes) => notes.id == id);
    }
    catch (_){
      return null;
    }
  }
}