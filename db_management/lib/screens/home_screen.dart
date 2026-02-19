import 'package:flutter/material.dart';
import 'package:db_management/db_connection.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DbConnection dbRef = DbConnection.instance;
  List<Map<String, dynamic>> notes = [];
  bool isLoading = true;
  String selectedDate = DateTime.now().toString().split(' ')[0];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    setState(() => isLoading = true);
    try {
      final allNotes = await dbRef.getAllNotes();
      setState(() {
        notes = allNotes;
      });
      print("Loaded ${notes.length} notes");
    } catch (e) {
      print("Error loading notes: $e");
      _showError("Error loading notes: $e");
    }
    setState(() => isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _deleteNote(int id) async {
    try {
      await dbRef.deleteNote(id);
      await loadNotes();
      _showSuccess("Note deleted successfully");
    } catch (e) {
      _showError("Error deleting note: $e");
    }
  }

  List<Map<String, dynamic>> getNotesForDate(String date) {
    return notes.where((note) => note['date'] == date).toList();
  }

  @override
  Widget build(BuildContext context) {
    final todayNotes = getNotesForDate(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Notes'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Date selector
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          final newDate = DateTime.parse(
                            selectedDate,
                          ).subtract(const Duration(days: 1));
                          setState(() {
                            selectedDate = newDate.toString().split(' ')[0];
                          });
                        },
                      ),
                      Column(
                        children: [
                          Text(
                            selectedDate,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${todayNotes.length} notes',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          final newDate = DateTime.parse(
                            selectedDate,
                          ).add(const Duration(days: 1));
                          setState(() {
                            selectedDate = newDate.toString().split(' ')[0];
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Notes list
                Expanded(
                  child: todayNotes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.note_add,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "No notes for this day",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text("Add First Note"),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddNoteScreen(date: selectedDate),
                                    ),
                                  );
                                  loadNotes();
                                },
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: todayNotes.length,
                          itemBuilder: (context, index) {
                            final note = todayNotes[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 2,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  note['title'] ?? 'No Title',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  note['subtitle'] ?? 'No subtitle',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: const Text('Edit'),
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditNoteScreen(note: note),
                                          ),
                                        );
                                        loadNotes();
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Delete Note"),
                                            content: const Text(
                                              "Are you sure?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _deleteNote(note['id']);
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(date: selectedDate),
            ),
          );
          loadNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
