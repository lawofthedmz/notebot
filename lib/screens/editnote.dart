import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_bot/screens/bottomnavbar.dart';
import 'package:note_bot/screens/sidebar.dart';

class EditNoteScreen extends StatefulWidget {
  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    // Implement your save logic here
    print('Saving note:');
    print('Title: ${_titleController.text}');
    print('Content: ${_contentController.text}');
  }

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    return Scaffold(
      extendBody: true,
      bottomNavigationBar:
          MediaQuery.of(context).size.width < 800 ? BottomNavBar() : null,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF712A89), Color(0xFF140609)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // SVG Overlay
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/background.svg',
              fit: BoxFit.cover,
            ),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 800) {
                return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: constraints.maxHeight,
                        child: Sidebar(),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, top: 70.0, bottom: 30.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(73, 255, 255, 255),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                width: constraints.maxWidth / 3,
                                child: TextField(
                                  controller: _titleController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Enter title',
                                    hintStyle: TextStyle(color: Colors.white70),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: SizedBox(
                                width: constraints.maxWidth / 2,
                                height: 300.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(73, 255, 255, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  child: TextField(
                                    controller: _contentController,
                                    style: TextStyle(color: Colors.white),
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: 'Enter note content',
                                      hintStyle:
                                          TextStyle(color: Colors.white70),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 51.0, right: 27.0),
                                  child: ElevatedButton(
                                    onPressed: _saveNote,
                                    child: Text("Save"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 51.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Implement cancel logic
                                    },
                                    child: Text("Cancel"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // Mobile layout remains unchanged
                return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 30.0),
                              width: constraints.maxWidth,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.white)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  "Edit Note",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 49.0,
                                bottom: 30.0,
                              ),
                              child: SizedBox(
                                height: 40.0,
                                width: constraints.maxWidth - 70,
                                child: TextField(
                                  controller: _titleController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(73, 255, 255, 255),
                                    hintText: 'Enter title',
                                    hintStyle: TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth - 70.0,
                              height:
                                  MediaQuery.of(context).size.height - 350.0,
                              child: RawScrollbar(
                                thumbVisibility: false,
                                controller: _scrollController,
                                child: TextField(
                                  expands: true,
                                  controller: _contentController,
                                  style: TextStyle(color: Colors.white),
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(73, 255, 255, 255),
                                    hintText: 'Enter note content',
                                    hintStyle: TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(35.0)),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30.0, right: 27.0),
                                  child: ElevatedButton(
                                    onPressed: _saveNote,
                                    child: Text("Save"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Implement cancel logic
                                    },
                                    child: Text("Cancel"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
