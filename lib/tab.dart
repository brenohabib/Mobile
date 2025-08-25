import 'package:flutter/material.dart';

void main() => runApp(const TabBarApp());

class TabBarApp extends StatelessWidget {
  const TabBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TabPage());
  }
}

class TabPage extends StatelessWidget {
  const TabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.code)),
              Tab(icon: Icon(Icons.menu)),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(child: Text("Tab 1")),
            Center(child: Text("Tab 2")),
            Center(child: Text("Tab 3")),
          ],
        ),
      ),
    );
  }
}