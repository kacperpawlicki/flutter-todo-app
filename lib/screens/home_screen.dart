import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/stats_screen.dart';
import 'package:flutter_todo_app/screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        toolbarHeight: 80,
        title: Text(
          selectedIndex == 0 ? "Todos" : "Stats",
          style: TextStyle(fontSize: 52, fontWeight: FontWeight.w500),
        ),
      ),

      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.list), label: "To do"),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: "Stats"),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),

      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {},
              shape: CircleBorder(),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              child: Icon(Icons.add),
            )
          : null,

      body: IndexedStack(
        index: selectedIndex,
        children: [TodoScreen(), StatsScreen()],
      ),
    );
  }
}
