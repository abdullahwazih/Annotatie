import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _items = [];

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _items.add(text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Items to List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter item',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ),
              onSubmitted: (_) => _addItem(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _items.isEmpty
                  ? Center(child: Text('No items yet.'))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return ListTile(title: Text(_items[index]));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
