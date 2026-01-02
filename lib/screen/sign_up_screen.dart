import 'package:flutter/material.dart';
import 'package:note_taker_app/screen/home_screen.dart';
import 'package:note_taker_app/view_model/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Text("Sign Up", style: Theme.of(context).textTheme.headlineLarge),
                SizedBox(height: 40),
                TextField(
                  controller: authProvider.userNameController,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(hintText: "Enter your user name: "),
                ),
                SizedBox(height: 20),
          
                TextField(
                  controller: authProvider.ageController,
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Enter your user age: "),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: authProvider.emailController,
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: "Enter your user email: "),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: authProvider.passController,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: "Enter your user password: ",
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    authProvider.isEmailExist(authProvider.emailController.text);
                    final success = authProvider.signUp();
                    if (await success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Email already exists")),
                      );
                    }
                  },
                  child: Text(
                    "Sign up",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  ),
                  child: Text("Skip"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
