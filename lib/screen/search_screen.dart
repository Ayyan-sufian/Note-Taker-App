import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool _isWrong = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search by the keyboard",
                          suffixIcon: IconButton(
                            onPressed: () {
                              searchController.clear();
                            },
                            icon: Icon(Icons.close),
                          ),
                        ),
                        cursorColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                _isWrong
                    ? SizedBox()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("assets/img/search_img.png"),
                          SizedBox(height: 10,),
                          Text(
                            "File not found. Try searching again.",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
