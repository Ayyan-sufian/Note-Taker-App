import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_taker_app/models/user_model.dart';
import 'package:note_taker_app/services/firebase_service.dart';
import 'package:note_taker_app/view_model/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AuthProvider extends ChangeNotifier {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final Box<UserModel> _userBox = Hive.box<UserModel>('userBox');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService _firebaseService = FirebaseService();

  bool _isLoggedIn = false;
  String? _currentUserId;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserId => _currentUserId;

  final Uuid uuid = Uuid();

  /// Check if email already exists locally
  bool isEmailExist(String email) {
    return _userBox.containsKey(email.trim());
  }

  /// SIGN UP (Local + Firebase)
  Future<bool> signUp() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();
    final name = userNameController.text.trim();
    final int age = int.tryParse(ageController.text) ?? 0;

    // CONDITIONS
    if (email.isEmpty || password.isEmpty || name.isEmpty) return false;
    if (_userBox.containsKey(email)) return false;

    final userId = uuid.v4();

    final user = UserModel(
      userId: userId,
      userToken: null,
      userName: name,
      age: age,
      email: email,
      password: password,
    );


    await _userBox.put(email, user);


    await _firestore.collection('users').doc(userId).set({
      'userId': userId,
      'name': name,
      'email': email,
      'age': age,
      'createdAt': Timestamp.now(),
    });


    _isLoggedIn = true;
    _currentUserId = userId;

    Hive.box('sessionBox').put('userId', userId);

    notifyListeners();
    return true;
  }

  /// LOGIN (Local only)
  Future<bool> login(String email, String password) async {
    final trimmedEmail = email.trim();
    final trimmedPass = password.trim();

    final user = _userBox.get(trimmedEmail);

    if (user != null && user.password == trimmedPass) {
      _isLoggedIn = true;
      _currentUserId = user.userId;

      Hive.box('sessionBox').put('userId', user.userId);
      notifyListeners();
      return true;
    } else {
      // Try fetching user from Firebase
      final firebaseUser = await _firebaseService.callFirebaseUser(
          trimmedEmail, trimmedPass);
      if (firebaseUser != null) {
        _isLoggedIn = true;
        _currentUserId = firebaseUser.userId;
        Hive.box('sessionBox').put('userId', firebaseUser.userId);
        notifyListeners();
        return true;
      }
    }

    final firebaseUser =
    await _firebaseService.callFirebaseUser(trimmedEmail, trimmedPass);

    if (firebaseUser != null) {
      _isLoggedIn = true;
      _currentUserId = firebaseUser.userId;

      Hive.box('sessionBox').put('userId', firebaseUser.userId);
      notifyListeners();
      return true;
    }

    return false;
  }

  /// LOGOUT
  void logOut(BuildContext context) {
    _isLoggedIn = false;
    _currentUserId = null;

    Provider.of<NotesProvider>(context, listen: false).clearNotes();
    Hive.box('sessionBox').clear();

    notifyListeners();
  }


  /// RESTORE SESSION
  void restoreSession() {
    final sessionBox = Hive.box('sessionBox');
    final userId = sessionBox.get('userId');

    if (userId != null) {
      _isLoggedIn = true;
      _currentUserId = userId;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}
