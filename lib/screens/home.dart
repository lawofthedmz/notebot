import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_bot/screens/bottomnavbar.dart';
import 'package:note_bot/screens/sidebar.dart';

class HomeScreen extends StatelessWidget {
  final List<String> items = List.generate(20, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
final _controller = ScrollController();
return Scaffold(
  extendBody: true,
  bottomNavigationBar: MediaQuery.of(context).size.width < 800 ?  BottomNavBar(): null,
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
                          padding: const EdgeInsets.only(left: 30.0, top: 70.0, bottom: 30.0),
                          child: SizedBox(
                            height: 30.0,
                            width: constraints.maxWidth / 3,
                            child: SearchBarModule(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: SizedBox(
                            width: constraints.maxWidth / 2,
                            height: 300.0,
                            child: RawScrollbar(
                              thumbColor: Colors.white,
                              radius: Radius.circular(50.0),
                              thickness: 10.0,
                              thumbVisibility: true,
                              controller: _controller,
                              child: ListWidget(items: items, Scontroller: _controller),
                            ),
                          ),
                        ),
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
                        Container(margin: EdgeInsets.only(top: 30.0,), width: constraints.maxWidth, decoration:BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))), child:Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text("Notes", textAlign: TextAlign.center, style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0), ),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 30.0, bottom: 30.0),
                          child: SizedBox(
                            height: 30.0,
                            width: constraints.maxWidth - 150,
                            child: SearchBarModule(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: SizedBox(
                            width: constraints.maxWidth - 100.0,
                            height: MediaQuery.of(context).size.height-250.0,
                            child: RawScrollbar(
                              thumbVisibility: false,
                              controller: _controller,
                              child: ListWidget(items: items, Scontroller: _controller),
                            ),
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

class ListWidget extends StatelessWidget {
  const ListWidget({super.key, required this.items, required this.Scontroller});

  final List<String> items;
  final ScrollController Scontroller;
  @override
  Widget build(BuildContext context) {
     return  ListView(
                          controller: Scontroller,
                          shrinkWrap: true,
                          children: items.map((item) {
                            return Container(
                              width: 2.0,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.white),
                                  bottom: BorderSide(color: Colors.white),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  item,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }).toList(growable: false),
                        );
                      
  }
}

class SearchBarModule extends StatefulWidget {
  const SearchBarModule({super.key});

  @override
  State<SearchBarModule> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarModule> {
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SizedBox(
          width: 2.0,
          child: SearchBar(
            controller: controller,
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Row(children: const [Icon(Icons.search_rounded, color: Colors.white,), Text("Search", style: TextStyle(color: Colors.white),)]),
            backgroundColor: WidgetStateProperty.all(Color.fromARGB(34, 0, 0, 0)),
          ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            },
          );
        });
      },
    );
  }
}