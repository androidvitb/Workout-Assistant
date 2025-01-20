import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:workout_assistant/other_dart_files/create_plan.dart';
import 'package:workout_assistant/other_dart_files/firebase_db.dart';
import 'package:workout_assistant/other_dart_files/login.dart';

// import 'package:new_project/services/local_database.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp();
  // await LocalDatabase.instance.initializeDatabase(); // Initialize SQLite or local database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workout Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SidebarNavigation(),
    );
  }
}

class SidebarNavigation extends StatefulWidget {
  const SidebarNavigation({super.key});

  @override
  SidebarNavigationState createState() => SidebarNavigationState();
}

class SidebarNavigationState extends State<SidebarNavigation> {
  int _selectedIndex = 0;
  String? userName = 'User';

  final List<Widget> _pages = [
    const HomeScreen(),
    const CreatePlanScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            autofocus: true,
            onPressed: () async {
              userName = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Create Plan'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Home Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Settings Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
