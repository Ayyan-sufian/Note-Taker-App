import 'package:flutter/material.dart';
import 'package:note_taker_app/screen/splash_screen.dart';
import 'package:note_taker_app/screen/themes/app_theme.dart';
import 'package:note_taker_app/view_model/notes_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => NotesProvider(),child: const MyApp(),)); // From here we use provider in this app.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noted Taker App',
      theme: AppTheme.darkTheme, // We create theme app
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
