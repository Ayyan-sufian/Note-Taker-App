import 'package:flutter/material.dart';
import 'package:note_taker_app/screen/home_screen.dart';
import 'package:note_taker_app/screen/sign_up_screen.dart';
import 'package:note_taker_app/view_model/auth_provider.dart';
import 'package:provider/provider.dart';

import '../view_model/notes_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController lEmailController = TextEditingController();
  TextEditingController lPassController = TextEditingController();

  Future<void> _handleLogin() async {
    final notesProvider = context.read<NotesProvider>();
    final authProvider = context.read<AuthProvider>();

    bool success = await authProvider.login(
      lEmailController.text,
      lPassController.text,
    );

    if (!mounted) return; // It checks that is there is any changes in widget or not

    if (success) {
      await notesProvider.syncNotes(authProvider.currentUserId!);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login", style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 40),
            TextField(
              controller: lEmailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.white,
              decoration: InputDecoration(hintText: "Enter your user email: "),
            ),
            SizedBox(height: 20),
            TextField(
              controller: lPassController,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "Enter your user password: ",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _handleLogin();
              },
              child: Text(
                "Login",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text("Sign up", style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
