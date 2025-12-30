import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:note_taker_app/screen/login_screen.dart';
import 'package:note_taker_app/screen/notes_screen.dart';
import 'package:note_taker_app/screen/search_screen.dart';
import 'package:note_taker_app/screen/themes/app_theme.dart';
import 'package:note_taker_app/view_model/notes_provider.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../view_model/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void infoBox() {
    showDialog(
      barrierDismissible: true,
      barrierColor: AppTheme.secColor.withOpacity(0.5),
      context: context,
      builder: (context) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        return Dialog(
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Designed by- Ayan Sufian",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    authProvider.logOut(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                  },
                  child: const Text("Log out"),
                )
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final notesProvider = Provider.of<NotesProvider>(context, listen: true);

    // Only show notes for logged-in user
    final userNotes = authProvider.currentUserId != null
        ? notesProvider.getNotesForUser(authProvider.currentUserId!)
        : [];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text("Notes", style: GoogleFonts.nunito()),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
            icon: Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0XFF3B3B3B),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.search),
            ),
          ),
          IconButton(
            onPressed: () {
              infoBox();
            },
            icon: Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0XFF3B3B3B),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.info_outline_rounded),
            ),
          ),
        ],
      ),
      body: userNotes.isEmpty
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/img/empty_screen.png"),
                    Text(
                      "Create your first note !",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: userNotes.length,
              itemBuilder: (context, index) {
                final note = userNotes[index];
                return Dismissible(
                  key: ValueKey(note.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  confirmDismiss: (direction) async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete note?"),
                        content: const Text("This note will be permanently deleted."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel",style: TextStyle(color: Colors.white),),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (shouldDelete == true) {
                      notesProvider.deleteNote(note.id);
                      return true;
                    }

                    return false;
                  },

                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 25),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotesScreen(noteId: note.id),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 17),
                        decoration: BoxDecoration(
                          color: AppTheme.colorList[
                          index % AppTheme.colorList.length],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          note.title,
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotesScreen()),
          );
        },
        child: Icon(Icons.add, size: 28),
      ),
    );
  }
}
