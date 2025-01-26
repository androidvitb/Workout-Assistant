import 'package:flutter/material.dart';
import 'package:workout_assistant/dart_files/firebase_db.dart';
import 'package:workout_assistant/dart_files/workout_session.dart';

//
// this take care of logic of how the data which is fetched will be printed in screen for user to see
// here i have written the logic for the database in which i am storing the data as per my
// format of storing
//
// if you want to change that the look into firebase_db.dart
//
// this show the data using a listbuilder as for to get a single plan from whole data then putting
// it into a list then do the same for all other datas then display it.
//
// and on clicking a list on the page there is a function which will redirect the user
// to workout session page where we can send the data of the listtile user clicked
//
// for further development of this app you can continue from here:
//
// 1. send all detail of the listtile user clicked
// 2. then modify the workout_session.dart ............

class DisplayDataScreen extends StatefulWidget {
  final String username;

  const DisplayDataScreen({super.key, required this.username});

  @override
  State<DisplayDataScreen> createState() => _DisplayDataScreenState();
}

class _DisplayDataScreenState extends State<DisplayDataScreen> {
  late Future<Map<String, Map<String, dynamic>>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = getData(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: FutureBuilder<Map<String, Map<String, dynamic>>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No data available'),
            );
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final title = data.keys.elementAt(index); // "a"
                final itemData = data[title]!;

                return CustomDataWidget(
                  title: title, // Display "a"
                  item: itemData["item"],
                  category: itemData["category"],
                  duration: itemData["duration"],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CustomDataWidget extends StatelessWidget {
  final String title;
  final String item;
  final String category;
  final int duration;

  const CustomDataWidget({
    super.key,
    required this.title,
    required this.item,
    required this.category,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showConfirmationDialog(context),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text("Item: $item"),
              Text("Category: $category"),
              Text("Duration: $duration minutes"),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Planner"),
          content: const Text("Do you want to start this workout session?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WorkoutSession(
                        title: title,
                        item: item,
                        category: category,
                        duration: duration), // Navigate to NextScreen
                  ),
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
