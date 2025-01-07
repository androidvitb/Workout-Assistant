import 'package:flutter/material.dart';

class CreatePlanScreen extends StatefulWidget {
  @override
  _CreatePlanScreenState createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final TextEditingController _titleController = TextEditingController();
  List<Map<String, dynamic>> _planItems = [];
  bool _isAddingItem = false;

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  // Focus nodes for managing focus
  final FocusNode _categoryFocusNode = FocusNode();
  final FocusNode _itemTitleFocusNode = FocusNode();
  final FocusNode _durationFocusNode = FocusNode();

  void _addItem() {
    if (_categoryController.text.isNotEmpty &&
        _itemTitleController.text.isNotEmpty &&
        _durationController.text.isNotEmpty) {
      setState(() {
        _planItems.add({
          'category': _categoryController.text,
          'title': _itemTitleController.text,
          'duration': int.tryParse(_durationController.text) ?? 0,
        });
        _categoryController.clear();
        _itemTitleController.clear();
        _durationController.clear();
        _isAddingItem = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields before saving.')),
      );
    }
  }

  void _savePlan() {

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a title for the plan.')),
      );
      return;
    }
    print('ZZZZ');
    print('Plan Title: ${_titleController.text}');
    print('Plan Items: $_planItems');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plan saved successfully!')),
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _planItems.removeAt(index);
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers and focus nodes
    _titleController.dispose();
    _categoryController.dispose();
    _itemTitleController.dispose();
    _durationController.dispose();
    _categoryFocusNode.dispose();
    _itemTitleFocusNode.dispose();
    _durationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Plan'),
        actions: [
          ElevatedButton(
            onPressed: _savePlan,
            child: const Row(
              children: [
                Text("Save"),
                SizedBox(width: 5),
                Icon(Icons.save)
              ],
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Plan Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Plan Items List and Add Item Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isAddingItem)
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _itemTitleController,
                            focusNode: _itemTitleFocusNode,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_categoryFocusNode);
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _categoryController,
                            focusNode: _categoryFocusNode,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_durationFocusNode);
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _durationController,
                            focusNode: _durationFocusNode,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Duration (minutes)',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) {
                              _addItem(); // Call the add item function when done
                            },
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _addItem,
                            child: const Text('Save Item'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isAddingItem = true;
                      });
                      Future.delayed(const Duration(milliseconds: 100), () {
                        FocusScope.of(context).requestFocus(_itemTitleFocusNode);
                      });
                    },
                    child: const Text('Add Item'),
                  ),

                // Use a Container to limit the height of the ReorderableListView
                SizedBox(
                  height: 500, // Set a fixed height for the list view
                  child: ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final item = _planItems.removeAt(oldIndex);
                        _planItems.insert(newIndex, item);
                      });
                    },
                    children: [
                      for (int index = 0; index < _planItems.length; index++)
                        Card(
                          key: ValueKey(index),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(
                            leading: const Icon(Icons.drag_handle),
                            title: Text(_planItems[index]['title']),
                            subtitle: Text(
                              '${_planItems[index]['category']} - ${_planItems[index]['duration']} mins',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteItem(index),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
