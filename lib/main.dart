import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:workout_assistant/dart_files/create_plan.dart';
import 'package:workout_assistant/dart_files/home_screen.dart';
import 'package:workout_assistant/dart_files/setting_screen.dart';
import 'package:workout_assistant/dart_files/show_data.dart';
import 'package:workout_assistant/dart_files/login.dart';
import 'package:workout_assistant/dart_files/change_notifier.dart';
// import 'package:workout_assistant/dart_files/firebase_db.dart';

// import 'package:new_project/services/local_database.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp();
  // await LocalDatabase.instance.initializeDatabase(); // Initialize SQLite or local database

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  Widget _getPage(int index, String username) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return CreatePlanScreen(username: username);
      case 2:
        return const SettingsScreen();
      case 3:
        return DisplayDataScreen(username: username);
      default:
        return const HomeScreen();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = context.watch<UserProvider>().username;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Assistant'),
        actions: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return TextButton(
                onPressed: () {},
                child: Text(userProvider.username),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            autofocus: true,
            onPressed: () async {
              final username = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );

              if (username != null) {
                context.read<UserProvider>().setUsername(username);
              }
            },
          ),
        ],
      ),
      body: _getPage(_selectedIndex, username),
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
            ListTile(
              leading: const Icon(Icons.dataset),
              title: const Text('Show Data'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
