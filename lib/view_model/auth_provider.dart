import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_taker_app/models/user_model.dart';
import 'package:note_taker_app/view_model/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AuthProvider extends ChangeNotifier {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final Box<UserModel> _userBox = Hive.box<UserModel>("userBox");

  bool _isLoggedIn = false;
  String? _currentUserId;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserId => _currentUserId;

  final uuid = Uuid();

  /// Check if email already exists
  bool isEmailExist(String email) {
    return _userBox.values.any((user) => user.email == email);
  }

  /// Sign up a new user
  bool signUp() {
    final int age = int.tryParse(ageController.text) ?? 0;
    final email = emailController.text.trim();
    final password = passController.text.trim();

    if (email.isEmpty || password.isEmpty) return false;
    if (_userBox.containsKey(email)) return false;

    final user = UserModel(
      userId: uuid.v4(),
      userToken: null,
      userName: userNameController.text.trim(),
      age: age,
      email: email,
      password: password,
    );

    _userBox.put(email, user);

    _isLoggedIn = true;
    _currentUserId = user.userId;

    Hive.box('sessionBox').put('userId', user.userId);

    notifyListeners();
    return true;
  }

  /// Login existing user
  bool login(String email, String password) {
    final trimmedEmail = email.trim();
    final trimmedPass = password.trim();

    final user = _userBox.get(trimmedEmail);
    if (user != null && user.password == trimmedPass) {
      _isLoggedIn = true;
      _currentUserId = user.userId;

      Hive.box('sessionBox').put('userId', user.userId);

      notifyListeners();
      return true;
    }
    return false;
  }

  /// Logout user
  void logOut(BuildContext context) {
    _isLoggedIn = false;
    _currentUserId = null;

    // Clear user notes
    Provider.of<NotesProvider>(context, listen: false).clearNotes();

    Hive.box('sessionBox').clear();
    notifyListeners();
  }

  /// Restore session if userId exists
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
