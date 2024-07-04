import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_bot/screens/sidebar.dart';

class HomeScreen extends StatelessWidget {
  final List<String> items = List.generate(20, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    final _controller = ScrollController();
    return Scaffold(
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
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                SizedBox(height:MediaQuery.of(context).size.height, child: Sidebar()),
                Expanded(
                  child: Column(
                    
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0,top: 70.0,bottom: 30.0,),
                        child: SizedBox(height: 30.0, width: MediaQuery.of(context).size.width /3, child: SearchBarModule()),
                      ),
                         Padding(
                           padding: const EdgeInsets.only(left: 40.0),
                           child: SizedBox(width: MediaQuery.of(context).size.width /2, height: 300.0, child: RawScrollbar(        
                              thumbColor: Colors.white,
                              radius: Radius.circular(50.0),
                              thickness: 10.0,
                              thumbVisibility: true,
                              controller: _controller,
                              child: ListWidget(items: items, Scontroller: _controller,))),
                         ),
                  
                    ],
                  ),
                ),
            
              ],
            ),
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
            leading: const Icon(Icons.search),
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