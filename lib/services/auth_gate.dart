import 'package:flutter/material.dart';
import 'package:note_taker_app/view_model/auth_provider.dart';
import 'package:provider/provider.dart';

import '../screen/home_screen.dart';
import '../screen/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return auth.isLoggedIn
            ? const HomeScreen()
            : const LoginScreen();
      },
    );
      }
}
