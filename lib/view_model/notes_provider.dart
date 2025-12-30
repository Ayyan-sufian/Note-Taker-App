import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_taker_app/models/notes_model.dart';
import 'package:uuid/uuid.dart';

class NotesProvider extends ChangeNotifier {
  final Box<NotesModel> _notesBox = Hive.box<NotesModel>('notesBox');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = Uuid();

  /// Get notes only for logged-in user
  List<NotesModel> getNotesForUser(String userId) {
    return _notesBox.values.where((note) => note.userId == userId).toList();
  }

  /// Clear all notes locally (used on logout)
  Future<void> clearNotes() async {
    await _notesBox.clear();
    notifyListeners();
  }

  /// Get single note by id
  NotesModel? getNoteById(String id) {
    return _notesBox.get(id);
  }

  /// Add a new note
  Future<void> addNote({
    required String title,
    required String content,
    required String userId,
  }) async {
    final String noteId = _uuid.v4();

    final note = NotesModel(
      id: noteId,
      userId: userId,
      title: title.trim(),
      content: content.trim(),
    );

    // Save locally
    await _notesBox.put(noteId, note);

    // Save to Firestore
    await _firestore.collection('notes').doc(noteId).set({
      'noteId': noteId,
      'userId': userId,
      'title': note.title,
      'content': note.content,
      'createdAt': Timestamp.now(),
    });

    notifyListeners();
  }

  /// Update an existing note
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    final note = _notesBox.get(noteId);
    if (note == null) return;

    note.title = title.trim();
    note.content = content.trim();
    await note.save();

    await _firestore.collection('notes').doc(noteId).update({
      'title': note.title,
      'content': note.content,
    });

    notifyListeners();
  }

  /// Delete a note
  Future<void> deleteNote(String noteId) async {
    await _notesBox.delete(noteId);
    await _firestore.collection('notes').doc(noteId).delete();

    notifyListeners();
  }

  /// Fetch notes from Firestore for a specific user
  Future<void> syncNotes(String userId) async {
    final snapshot = await _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .get();

    // Clear local notes for this user first
    final userNotes = _notesBox.values
        .where((note) => note.userId == userId)
        .toList();
    // This is use to remove old notes
    for (var note in userNotes) {
      _notesBox.delete(note.id);
    }

    // This loop is use for add new notes that are the notes of current user
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final note = NotesModel(
        id: doc.id,
        userId: data['userId'] ?? userId,
        title: (data['title'] ?? '').toString(),
        content: (data['content'] ?? '').toString(),
      );
      _notesBox.put(note.id, note);
    }

    notifyListeners();
  }
}
