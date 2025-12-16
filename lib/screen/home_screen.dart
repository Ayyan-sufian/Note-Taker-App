import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_taker_app/screen/notes_screen.dart';
import 'package:note_taker_app/screen/search_screen.dart';
import 'package:note_taker_app/themes/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isScreenEmpty = true;

  void infoBox() {
    showDialog(
      barrierDismissible: true,
      barrierColor: AppTheme.secColor.withOpacity(0.5),
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: 100,
            width: 100,
            child: Center(
              child: Text(
                "Designed by- Ayan Sufian",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        );
      },
    );
  }

  List Testing = [
    {
      'title': 'Hello world!',
      'subtitle': 'Hi everyone! Welcome to My notes taker app.',
    },
    {
      'title': 'Food recipe',
      'subtitle': 'Hi everyone! Welcome to My notes taker app.',
    },
    {
      'title': 'Phone NO.',
      'subtitle': 'Hi everyone! Welcome to My notes taker app.',
    },
    {
      'title': 'Hello world!',
      'subtitle': 'Hi everyone! Welcome to My notes taker app.',
    },
    {
      'title': 'Hello world!',
      'subtitle': 'Hi everyone! Welcome to My notes taker app.',
    },
    {
      'title': 'Hello world!',
      'subtitle': 'Hi everyone! Welcome to My notes taker app.',
    },
    {
      'title':
          'Hello world!hwefsdhfosndfcshfshfsfhifnshfofnosinfosnfoishfonsufsod',
      'subtitle': 'Hi everyone! Welcome to My notes taker app.',
    },
    {
      'title': 'Hello world!',
      'subtitle': 'Hi everyone! Welcome to My notes taker app.',
    },
    {
      'title': 'Hellodnlsnsfnsjfdsjfsjdfinsh world!',
      'subtitle': 'Hi everyone! Welcome to My notes taker app.',
    },
    {
      'title': 'Hello world!',
      'subtitle': 'Hi everyone! Welcome to My notes taker app.',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
      body: _isScreenEmpty
          ? Center(
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
            )
          : ListView.builder(
              itemCount: Testing.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(Testing[index]),
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
                  onDismissed: (direction) {
                    setState(() {
                      Testing.removeAt(index);
                    });
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete note?"),
                        content: const Text(
                          "This note will be permanently deleted.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
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
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 25,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 45,
                        horizontal: 17,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme
                            .colorList[index % AppTheme.colorList.length],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        Testing[index]["title"],
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
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
