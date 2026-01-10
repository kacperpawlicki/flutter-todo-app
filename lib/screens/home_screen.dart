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
      appBar: AppBar(title: Text("To do"), centerTitle: true),

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

      body: IndexedStack(
        index: selectedIndex,
        children: [
          TodoScreen(),
          StatsScreen()
        ],
      ),
    );
  }
}
