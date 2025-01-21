import 'package:flutter/material.dart';
import 'package:workout_assistant/dart_files/firebase_db.dart';

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
        title: Text('Display Data (${widget.username})'),
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
    return Card(
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
    );
  }
}
