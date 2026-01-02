import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';

import '../models/notes_model.dart';
import '../models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<UserModel?> callFirebaseUser(String email, String pass) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      final doc = query.docs.first;
      final data = doc.data();

      final user = UserModel(
        userId: doc.id,
        userName: data['name'] ?? '',
        age: data['age'] ?? 0,
        email: data['email'] ?? '',
        password: pass,
        userToken: null,
      );

      final userBox = Hive.box<UserModel>('userBox');


      await userBox.put(user.email.trim(), user);

      return user;
    } catch (e) {
      print('Firebase fetch error: $e');
      return null;
    }
  }

  Future<void> fetchNotesFromFirebase(String userId) async {
    try {
      final Box<NotesModel> notesBox =
      Hive.box<NotesModel>('notesBox');

      final snapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        final note = NotesModel(
          id: doc.id,
          title: data['title'] ?? '',
          content: data['content'] ?? '',
          userId: data['userId'],
        );


        await notesBox.put(note.id, note);
      }
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }
}