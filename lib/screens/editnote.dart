import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_bot/screens/bottomnavbar.dart';
import 'package:note_bot/screens/sidebar.dart';

class EditNoteScreen extends StatelessWidget {
  final List<String> items = List.generate(20, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    final _controller = ScrollController();
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
          // SearchBarModule(),
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
                                  decoration: BoxDecoration(color: Color.fromARGB(73, 255, 255, 255), borderRadius: BorderRadius.all(Radius.circular(35.0))),
                                height: 30.0,
                                width: constraints.maxWidth / 3,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: SizedBox(
                                width: constraints.maxWidth / 2,
                                height: 300.0,
                                child: Container(
                                  decoration: BoxDecoration(color: Color.fromARGB(73, 255, 255, 255), borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                  height: 30.0,
                                  width: constraints.maxWidth / 3,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 51.0, right: 27.0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(),
                                      onPressed: () {}, child: Text("Save")),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:51.0),
                                  child: ElevatedButton(
                                      onPressed: () {}, child: Text("Cancel")),
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
                                margin: EdgeInsets.only(
                                  top: 30.0,
                                ),
                                width: constraints.maxWidth,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.white))),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    "Notes",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, top: 30.0, bottom: 30.0),
                              child: SizedBox(
                                height: 30.0,
                                width: constraints.maxWidth - 150,
                                child: Text("Hi"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SizedBox(
                                width: constraints.maxWidth - 100.0,
                                height:
                                    MediaQuery.of(context).size.height - 250.0,
                                child: RawScrollbar(
                                    thumbVisibility: false,
                                    controller: _controller,
                                    child: Text("Hi")),
                              ),
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
