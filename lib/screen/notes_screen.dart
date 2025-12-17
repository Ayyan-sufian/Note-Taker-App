import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:note_taker_app/screen/themes/app_theme.dart';
import 'package:note_taker_app/view_model/notes_provider.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  final String? noteId; // this is use to get note id
  const NotesScreen({super.key, this.noteId});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication(); // We can use local auth from this line for security

  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); // Always call super to ensure the parent class can handle dependency changes properly
    if (widget.noteId != null) {
      final note = context.read<NotesProvider>().getNotesById(widget.noteId!);
        if(note != null){
          titleController.text = note.title; // this is use for editing title
          contentController.text = note.content; // this is use for editing content
        }
    }
  }

  /// This is use to ask to add pin and fingerprint
  Future<void> authenticate() async {
    try {
      final bool isSupported = await auth.isDeviceSupported();

      if (!isSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication not supported on this device")),
        );
        return;
      }

      final bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Authenticate to view this note', // show when the auth dialog box open
          biometricOnly: false, // Form this we can use pin, face lock and fingerprint
      );

      if (isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Note is now hide.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication failed")),
        );
      }
    } catch (e) {
      debugPrint("Auth error: $e");
    }
  }

  /// save the notes
  void saveNotes() {
    final provider = context.read<NotesProvider>();
    if (widget.noteId == null) {
      provider.addNotes(titleController.text, contentController.text); // It is use to create notes
    }  else{
      provider.updateNote(widget.noteId!, titleController.text, contentController.text); // It is use to update notes
    }
    Navigator.pop(context);
  }


  /// It's use to show dialog box for save notes
  void showSaveChangesDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppTheme.secColor.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, color: Colors.grey, size: 40),
                const SizedBox(height: 16),
                const Text(
                  'Save changes ?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Discard'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.successColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          saveNotes();
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// It's use to show dialog box
  void showCloseDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppTheme.secColor.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, color: Colors.grey, size: 40),
                const SizedBox(height: 16),
                const Text(
                  'Are your sure you want discard your changes ?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Discard'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.successColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Keep'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () => showCloseDialog(context),
            icon: Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color(0XFF3B3B3B),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ),

        actions: [
          IconButton(
            onPressed: () async {
              await authenticate();
            },
            icon: Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0XFF3B3B3B),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.remove_red_eye_outlined),
            ),
          ),
          IconButton(
            onPressed: () {
              showSaveChangesDialog(context);
            },
            icon: Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0XFF3B3B3B),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.save_outlined),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: GoogleFonts.nunito(
                  fontSize: 48,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFF9A9A9A),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
              ),
              style: GoogleFonts.nunito(
                fontSize: 35,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              cursorColor: Colors.white,

              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            SizedBox(height: 8),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                hintText: "Type something...",
                hintStyle: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFF9A9A9A),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
              ),
              style: GoogleFonts.nunito(
                fontSize: 23,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),

              cursorColor: Colors.white,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
